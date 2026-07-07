package Controller;

import Model.Competition;
import Model.Match;
import Model.Sport;
import DAO.SportDAO;
import DAO.CompetitionDAO;
import DAO.MatchDAO;
import DAO.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "matchesServlet", urlPatterns = {"/matches"})
public class MatchesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SportDAO sportDAO = new SportDAO();
        CompetitionDAO competitionDAO = new CompetitionDAO();
        MatchDAO matchDAO = new MatchDAO();

        Integer sportId = parseIdOrNull(request.getParameter("sportId"));
        Integer competitionId = parseIdOrNull(request.getParameter("competitionId"));

        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = (sportId != null)
                ? competitionDAO.selectCompetitionsBySport(sportId)
                : competitionDAO.selectAllCompetitions();

        if (competitionId != null && !belongsTo(competitions, competitionId)) {
            competitionId = null;
        }

        List<Match> matches;
        if (competitionId != null) {
            matches = matchDAO.selectMatchesByCompetition(competitionId);
        } else if (sportId != null) {
            matches = matchDAO.selectMatchesBySport(sportId);
        } else {
            matches = matchDAO.selectAllMatches();
        }

        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.setAttribute("matches", matches);
        request.setAttribute("selectedSportId", sportId);
        request.setAttribute("selectedCompetitionId", competitionId);

        request.getRequestDispatcher("/matches.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String matchIdParam = request.getParameter("matchId");
        String score1Param = request.getParameter("score1");
        String score2Param = request.getParameter("score2");
        String status = request.getParameter("status"); // e.g. "FINISHED"

        if (matchIdParam != null && score1Param != null && score2Param != null) {
            try {
                int matchId = Integer.parseInt(matchIdParam);
                int score1 = Integer.parseInt(score1Param);
                int score2 = Integer.parseInt(score2Param);

                MatchDAO matchDAO = new MatchDAO();

                // 1. Save match data to database row
                matchDAO.updateMatchResult(matchId, score1, score2, status);

                // 2. Adjust league standings metrics instantly if flagged finished
                if ("FINISHED".equalsIgnoreCase(status)) {
                    Match matchDetails = matchDAO.selectMatchById(matchId);
                    if (matchDetails != null) {
                        updateTeamStandingsMetrics(
                            matchDetails.getTeam1().getTeamId(),
                            matchDetails.getTeam2().getTeamId(),
                            score1,
                            score2
                        );
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Return back to match dashboard view cleanly
        response.sendRedirect(request.getContextPath() + "/matches");
    }

    /**
     * Increments games played, wins, draws, or losses inside team_statistics values.
     * team_statistics is keyed only by TEAM_ID (no COMPETITION_ID column exists on
     * that table), so standings are tracked per-team, not per-team-per-competition.
     */
    private void updateTeamStandingsMetrics(int t1Id, int t2Id, int s1, int s2) {
        // Resolve match outcome values
        int t1Win = (s1 > s2) ? 1 : 0;
        int t2Win = (s2 > s1) ? 1 : 0;
        int draw = (s1 == s2) ? 1 : 0;
        int t1Loss = (s1 < s2) ? 1 : 0;
        int t2Loss = (s2 < s1) ? 1 : 0;

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;

            // Ensure profile stat tracker entries exist for both teams to protect against blank updates
            ensureStatsRowExists(conn, t1Id);
            ensureStatsRowExists(conn, t2Id);

            // Update stats for Team 1
            String updateT1 = "UPDATE team_statistics SET GAMES_PLAYED = GAMES_PLAYED + 1, " +
                              "WINS = WINS + ?, DRAWS = DRAWS + ?, LOSSES = LOSSES + ? WHERE TEAM_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateT1)) {
                ps.setInt(1, t1Win);
                ps.setInt(2, draw);
                ps.setInt(3, t1Loss);
                ps.setInt(4, t1Id);
                ps.executeUpdate();
            }

            // Update stats for Team 2
            String updateT2 = "UPDATE team_statistics SET GAMES_PLAYED = GAMES_PLAYED + 1, " +
                              "WINS = WINS + ?, DRAWS = DRAWS + ?, LOSSES = LOSSES + ? WHERE TEAM_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateT2)) {
                ps.setInt(1, t2Win);
                ps.setInt(2, draw);
                ps.setInt(3, t2Loss);
                ps.setInt(4, t2Id);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Checks if a row exists in team_statistics for a team. If not, it safely creates one.
     */
    private void ensureStatsRowExists(Connection conn, int teamId) throws SQLException {
        String checkSql = "SELECT 1 FROM team_statistics WHERE TEAM_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, teamId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    String insertSql = "INSERT INTO team_statistics (TEAM_ID, GAMES_PLAYED, WINS, DRAWS, LOSSES) VALUES (?, 0, 0, 0, 0)";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, teamId);
                        insertPs.executeUpdate();
                    }
                }
            }
        }
    }

    private boolean belongsTo(List<Competition> competitions, int competitionId) {
        for (Competition c : competitions) {
            if (c.getCompetitionId() == competitionId) {
                return true;
            }
        }
        return false;
    }

    private Integer parseIdOrNull(String param) {
        if (param == null || param.isBlank() || param.equalsIgnoreCase("all")) {
            return null;
        }
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}