package Controller;

import Model.Competition;
import Model.Sport;
import DAO.CompetitionDAO;
import DAO.SportDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "competitionServlet", urlPatterns = {"/admin/competition"})
public class CompetitionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CompetitionDAO competitionDAO = new CompetitionDAO();
        SportDAO sportDAO = new SportDAO();
        List<Competition> competitionList = competitionDAO.selectAllCompetitions();
        List<Sport> sports = sportDAO.selectAllSports();
        request.setAttribute("competitionList", competitionList);
        request.setAttribute("sports", sports);
        request.getRequestDispatcher("/admin/competitions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CompetitionDAO competitionDAO = new CompetitionDAO();
        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            String sportIdParam = request.getParameter("sportId");
            String competitionName = request.getParameter("competitionName");
            String format = request.getParameter("format");
            String status = request.getParameter("status");
            if (sportIdParam != null && competitionName != null && !competitionName.isBlank()) {
                int sportId = Integer.parseInt(sportIdParam);
                Sport sport = new Sport();
                sport.setSportId(sportId);
                Competition comp = new Competition();
                comp.setSport(sport);
                comp.setCompetitionName(competitionName);
                comp.setFormat(format);
                comp.setStatus(status);
                competitionDAO.insertCompetition(comp);
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String competitionIdParam = request.getParameter("competitionId");
            String sportIdParam = request.getParameter("sportId");
            String competitionName = request.getParameter("competitionName");
            String format = request.getParameter("format");
            String status = request.getParameter("status");
            if (competitionIdParam != null && sportIdParam != null && competitionName != null && !competitionName.isBlank()) {
                int competitionId = Integer.parseInt(competitionIdParam);
                int sportId = Integer.parseInt(sportIdParam);
                Sport sport = new Sport();
                sport.setSportId(sportId);
                Competition comp = new Competition();
                comp.setCompetitionId(competitionId);
                comp.setSport(sport);
                comp.setCompetitionName(competitionName);
                comp.setFormat(format);
                comp.setStatus(status);
                competitionDAO.updateCompetition(comp);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String competitionIdParam = request.getParameter("competitionId");
            if (competitionIdParam != null) {
                int competitionId = Integer.parseInt(competitionIdParam);
                competitionDAO.deleteCompetition(competitionId);
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/competition");
    }
}