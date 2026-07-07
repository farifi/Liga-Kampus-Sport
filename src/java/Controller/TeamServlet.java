package Controller;

import Model.Team;
import Model.Sport;
import Model.Competition;
import DAO.TeamDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "teamServlet", urlPatterns = {"/admin/team"})
public class TeamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TeamDAO teamDAO = new TeamDAO();
        List<Team> teamList = teamDAO.selectAllTeams();

        request.setAttribute("teamList", teamList);
        request.getRequestDispatcher("/admin/teams.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sportIdParam = request.getParameter("sportId");
        String competitionIdParam = request.getParameter("competitionId");
        String teamName = request.getParameter("teamName");
        String coachName = request.getParameter("coachName");
        String faculty = request.getParameter("faculty");

        if (sportIdParam != null && competitionIdParam != null
                && teamName != null && !teamName.isBlank()) {
            try {
                int sportId = Integer.parseInt(sportIdParam);
                int competitionId = Integer.parseInt(competitionIdParam);

                Sport sport = new Sport();
                sport.setSportId(sportId);

                Competition competition = new Competition();
                competition.setCompetitionId(competitionId);

                Team team = new Team();
                team.setSport(sport);
                team.setCompetition(competition);
                team.setTeamName(teamName);
                team.setCoachName(coachName);
                team.setFaculty(faculty);

                new TeamDAO().insertTeam(team);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Redirect back so refreshing the page doesn't resubmit the form
        response.sendRedirect(request.getContextPath() + "/admin/team");
    }
}