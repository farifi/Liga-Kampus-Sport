package Controller;

import Model.Competition;
import Model.Match;
import Model.Sport;
import DAO.SportDAO;
import DAO.CompetitionDAO;
import DAO.MatchDAO;
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

        Integer sportId = parseIdOrNull(request.getParameter("sportId"));

        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = (sportId != null)
                ? competitionDAO.selectCompetitionsBySport(sportId)
                : competitionDAO.selectAllCompetitions();

        Competition selectedCompetition = resolveSelectedCompetition(request, competitions);
        List<Match> matches = (selectedCompetition != null)
                ? matchDAO.selectMatchesByCompetition(selectedCompetition.getCompetitionId())
                : Collections.emptyList();

        // Bind data models securely to the request scope
        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.setAttribute("selectedCompetition", selectedCompetition);
        request.setAttribute("matches", matches);
        request.setAttribute("selectedSportId", sportId);

        // Forward to the JSP located in your web root directory
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