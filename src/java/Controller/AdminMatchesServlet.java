package Controller;

import Model.Match;
import Model.Sport;
import Model.Competition;
import Model.Team;
import DAO.MatchDAO;
import DAO.SportDAO;
import DAO.CompetitionDAO;
import DAO.TeamDAO;
import DAO.TeamStatisticDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "adminMatchesServlet", urlPatterns = {"/admin/matches"})
public class AdminMatchesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MatchDAO matchDAO = new MatchDAO();
        SportDAO sportDAO = new SportDAO();
        CompetitionDAO competitionDAO = new CompetitionDAO();
        TeamDAO teamDAO = new TeamDAO();

        List<Match> matches = matchDAO.selectAllMatches();
        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = competitionDAO.selectAllCompetitions();
        List<Team> teams = teamDAO.selectAllTeams();

        request.setAttribute("matches", matches);
        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.setAttribute("teams", teams);

        request.getRequestDispatcher("/admin/matches.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MatchDAO matchDAO = new MatchDAO();
        TeamStatisticDAO statDAO = new TeamStatisticDAO();
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String sportIdParam = request.getParameter("sportId");
            String competitionIdParam = request.getParameter("competitionId");
            String team1IdParam = request.getParameter("team1Id");
            String team2IdParam = request.getParameter("team2Id");
            String venue = request.getParameter("venue");
            String date = request.getParameter("date");
            String score1Param = request.getParameter("score1");
            String score2Param = request.getParameter("score2");
            String status = request.getParameter("status");

            if (sportIdParam != null && competitionIdParam != null && team1IdParam != null && team2IdParam != null) {
                try {
                    int sportId = Integer.parseInt(sportIdParam);
                    int competitionId = Integer.parseInt(competitionIdParam);
                    int team1Id = Integer.parseInt(team1IdParam);
                    int team2Id = Integer.parseInt(team2IdParam);
                    int score1 = score1Param != null && !score1Param.isBlank() ? Integer.parseInt(score1Param) : 0;
                    int score2 = score2Param != null && !score2Param.isBlank() ? Integer.parseInt(score2Param) : 0;

                    Sport sport = new Sport();
                    sport.setSportId(sportId);

                    Competition comp = new Competition();
                    comp.setCompetitionId(competitionId);

                    Team t1 = new Team();
                    t1.setTeamId(team1Id);

                    Team t2 = new Team();
                    t2.setTeamId(team2Id);

                    Match match = new Match();
                    match.setSport(sport);
                    match.setCompetition(comp);
                    match.setTeam1(t1);
                    match.setTeam2(t2);
                    match.setVenue(venue);
                    match.setDate(date);
                    match.setScore1(score1);
                    match.setScore2(score2);
                    match.setStatus(status);

                    matchDAO.insertMatch(match);
                    statDAO.recalculateTeamStatistics(team1Id);
                    statDAO.recalculateTeamStatistics(team2Id);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String matchIdParam = request.getParameter("matchId");
            String sportIdParam = request.getParameter("sportId");
            String competitionIdParam = request.getParameter("competitionId");
            String team1IdParam = request.getParameter("team1Id");
            String team2IdParam = request.getParameter("team2Id");
            String venue = request.getParameter("venue");
            String date = request.getParameter("date");
            String score1Param = request.getParameter("score1");
            String score2Param = request.getParameter("score2");
            String status = request.getParameter("status");

            if (matchIdParam != null && sportIdParam != null && competitionIdParam != null && team1IdParam != null && team2IdParam != null) {
                try {
                    int matchId = Integer.parseInt(matchIdParam);
                    int sportId = Integer.parseInt(sportIdParam);
                    int competitionId = Integer.parseInt(competitionIdParam);
                    int team1Id = Integer.parseInt(team1IdParam);
                    int team2Id = Integer.parseInt(team2IdParam);
                    int score1 = score1Param != null && !score1Param.isBlank() ? Integer.parseInt(score1Param) : 0;
                    int score2 = score2Param != null && !score2Param.isBlank() ? Integer.parseInt(score2Param) : 0;

                    Sport sport = new Sport();
                    sport.setSportId(sportId);

                    Competition comp = new Competition();
                    comp.setCompetitionId(competitionId);

                    Team t1 = new Team();
                    t1.setTeamId(team1Id);

                    Team t2 = new Team();
                    t2.setTeamId(team2Id);

                    Match match = new Match();
                    match.setMatchId(matchId);
                    match.setSport(sport);
                    match.setCompetition(comp);
                    match.setTeam1(t1);
                    match.setTeam2(t2);
                    match.setVenue(venue);
                    match.setDate(date);
                    match.setScore1(score1);
                    match.setScore2(score2);
                    match.setStatus(status);

                    matchDAO.updateMatch(match);
                    statDAO.recalculateTeamStatistics(team1Id);
                    statDAO.recalculateTeamStatistics(team2Id);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String matchIdParam = request.getParameter("matchId");
            if (matchIdParam != null) {
                try {
                    int matchId = Integer.parseInt(matchIdParam);
                    Match matchDetails = matchDAO.selectMatchById(matchId);
                    if (matchDetails != null) {
                        int team1Id = matchDetails.getTeam1().getTeamId();
                        int team2Id = matchDetails.getTeam2().getTeamId();
                        matchDAO.deleteMatch(matchId);
                        statDAO.recalculateTeamStatistics(team1Id);
                        statDAO.recalculateTeamStatistics(team2Id);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/matches");
    }
}
