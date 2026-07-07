package Controller;

import Model.Competition;
import Model.Sport;
import Model.TeamStatistic;
import DAO.SportDAO;
import DAO.CompetitionDAO;
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

@WebServlet(name = "LeagueServlet", urlPatterns = {"/league"})
public class LeagueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SportDAO sportDAO = new SportDAO();
        CompetitionDAO competitionDAO = new CompetitionDAO();
        TeamStatisticDAO statDAO = new TeamStatisticDAO();

        // 1. Fetch selection dropdown lists for the sidebar/filters
        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = competitionDAO.selectAllCompetitions();

        // 2. Resolve which competition dashboard view is being requested
        Competition selectedCompetition = resolveSelectedCompetition(request, competitionDAO, competitions);
        
        // 3. Fetch raw standings statistics rows
        List<TeamStatistic> standings = (selectedCompetition != null)
                ? statDAO.selectStandingsByCompetition(selectedCompetition.getCompetitionId())
                : Collections.emptyList();

        // 4. MULTI-SPORT POINT LOGIC & SORTING
        // We look up the sport name from our selected competition context and do custom math
        if (selectedCompetition != null && !standings.isEmpty()) {
            final String sportName = (selectedCompetition.getSport() != null) 
                    ? selectedCompetition.getSport().getSportName() 
                    : "";

            // Sort descending by calculated points dynamically
            standings.sort((a, b) -> {
                int pointsA = PointsCalculator.calculatePoints(sportName, a.getWins(), a.getDraws());
                int pointsB = PointsCalculator.calculatePoints(sportName, b.getWins(), b.getDraws());

                // Highest points first
                int comparison = Integer.compare(pointsB, pointsA);

                // If points match, fewer games played ranks higher (more efficient record)
                if (comparison == 0) {
                    return Integer.compare(a.getGamesPlayed(), b.getGamesPlayed());
                }
                return comparison;
            });
        }

        // 5. Bind data models safely to the request context scope
        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.setAttribute("selectedCompetition", selectedCompetition);
        request.setAttribute("standings", standings);

        // 6. Forward data into the league view file tier
        request.getRequestDispatcher("/league.jsp").forward(request, response);
    }

    private Competition resolveSelectedCompetition(HttpServletRequest request,
                                                   CompetitionDAO competitionDAO,
                                                   List<Competition> competitions) {
        String competitionIdParam = request.getParameter("competitionId");

        if (competitionIdParam != null && !competitionIdParam.isBlank()) {
            try {
                int competitionId = Integer.parseInt(competitionIdParam);
                Competition found = competitionDAO.selectCompetitionById(competitionId);
                if (found != null) {
                    return found;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        // Default fallback case: load up the very first index entry item if available
        return competitions.isEmpty() ? null : competitions.get(0);
    }
}