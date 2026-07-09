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
        String status = request.getParameter("status");

        if (matchIdParam != null && score1Param != null && score2Param != null) {
            try {
                int matchId = Integer.parseInt(matchIdParam);
                int score1 = Integer.parseInt(score1Param);
                int score2 = Integer.parseInt(score2Param);

                MatchDAO matchDAO = new MatchDAO();
                matchDAO.updateMatchResult(matchId, score1, score2, status);

                Match matchDetails = matchDAO.selectMatchById(matchId);
                if (matchDetails != null) {
                    DAO.TeamStatisticDAO statDAO = new DAO.TeamStatisticDAO();
                    statDAO.recalculateTeamStatistics(matchDetails.getTeam1().getTeamId());
                    statDAO.recalculateTeamStatistics(matchDetails.getTeam2().getTeamId());
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/matches");
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