package Controller;

import Model.Competition;
import Model.Match;
import Model.Sport;
import Model.TeamStatistic;
import DAO.SportDAO;
import DAO.CompetitionDAO;
import DAO.MatchDAO;
import DAO.TeamStatisticDAO;
import Util.PointsCalculator;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "dashboardServlet", urlPatterns = {"/dashboard"})
public class dashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SportDAO sportDAO = new SportDAO();
        CompetitionDAO competitionDAO = new CompetitionDAO();
        MatchDAO matchDAO = new MatchDAO();
        TeamStatisticDAO statDAO = new TeamStatisticDAO();

        Integer sportId = parseIdOrNull(request.getParameter("sportId"));

        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = (sportId != null)
                ? competitionDAO.selectCompetitionsBySport(sportId)
                : competitionDAO.selectAllCompetitions();

        Competition selectedCompetition = resolveSelectedCompetition(request, competitions);
        List<Match> matches = (selectedCompetition != null)
                ? matchDAO.selectMatchesByCompetition(selectedCompetition.getCompetitionId())
                : Collections.emptyList();

        List<TeamStatistic> standings = (selectedCompetition != null)
                ? statDAO.selectStandingsByCompetition(selectedCompetition.getCompetitionId())
                : Collections.emptyList();

        if (selectedCompetition != null && !standings.isEmpty()) {
            final String sportName = (selectedCompetition.getSport() != null)
                    ? selectedCompetition.getSport().getSportName()
                    : "";

            standings.sort((a, b) -> {
                int pointsA = PointsCalculator.calculatePoints(sportName, a.getWins(), a.getDraws());
                int pointsB = PointsCalculator.calculatePoints(sportName, b.getWins(), b.getDraws());
                int comparison = Integer.compare(pointsB, pointsA);
                if (comparison == 0) {
                    return Integer.compare(a.getGamesPlayed(), b.getGamesPlayed());
                }
                return comparison;
            });
        }

        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.setAttribute("selectedCompetition", selectedCompetition);
        request.setAttribute("matches", matches);
        request.setAttribute("selectedSportId", sportId);
        request.setAttribute("standings", standings);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    private Integer parseIdOrNull(String param) {
        if (param == null || param.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    private Competition resolveSelectedCompetition(HttpServletRequest request,
                                                    List<Competition> competitions) {
        String competitionIdParam = request.getParameter("competitionId");

        if (competitionIdParam != null && !competitionIdParam.isBlank()) {
            try {
                int competitionId = Integer.parseInt(competitionIdParam);
                for (Competition c : competitions) {
                    if (c.getCompetitionId() == competitionId) {
                        return c;
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return competitions.isEmpty() ? null : competitions.get(0);
    }
}