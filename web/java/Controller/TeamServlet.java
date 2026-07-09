package Controller;

import Model.Team;
import Model.Sport;
import Model.Competition;
import DAO.TeamDAO;
import DAO.SportDAO;
import DAO.CompetitionDAO;
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
        SportDAO sportDAO = new SportDAO();
        CompetitionDAO competitionDAO = new CompetitionDAO();
        List<Team> teamList = teamDAO.selectAllTeams();
        List<Sport> sports = sportDAO.selectAllSports();
        List<Competition> competitions = competitionDAO.selectAllCompetitions();
        request.setAttribute("teamList", teamList);
        request.setAttribute("sports", sports);
        request.setAttribute("competitions", competitions);
        request.getRequestDispatcher("/admin/teams.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TeamDAO teamDAO = new TeamDAO();
        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            String sportIdParam = request.getParameter("sportId");
            String competitionIdParam = request.getParameter("competitionId");
            String teamName = request.getParameter("teamName");
            String coachName = request.getParameter("coachName");
            String faculty = request.getParameter("faculty");
            if (sportIdParam != null && competitionIdParam != null && teamName != null && !teamName.isBlank()) {
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
                    teamDAO.insertTeam(team);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String teamIdParam = request.getParameter("teamId");
            String sportIdParam = request.getParameter("sportId");
            String competitionIdParam = request.getParameter("competitionId");
            String teamName = request.getParameter("teamName");
            String coachName = request.getParameter("coachName");
            String faculty = request.getParameter("faculty");
            if (teamIdParam != null && sportIdParam != null && competitionIdParam != null && teamName != null && !teamName.isBlank()) {
                try {
                    int teamId = Integer.parseInt(teamIdParam);
                    int sportId = Integer.parseInt(sportIdParam);
                    int competitionId = Integer.parseInt(competitionIdParam);
                    Sport sport = new Sport();
                    sport.setSportId(sportId);
                    Competition competition = new Competition();
                    competition.setCompetitionId(competitionId);
                    Team team = new Team();
                    team.setTeamId(teamId);
                    team.setSport(sport);
                    team.setCompetition(competition);
                    team.setTeamName(teamName);
                    team.setCoachName(coachName);
                    team.setFaculty(faculty);
                    teamDAO.updateTeam(team);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String teamIdParam = request.getParameter("teamId");
            if (teamIdParam != null) {
                try {
                    int teamId = Integer.parseInt(teamIdParam);
                    teamDAO.deleteTeam(teamId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/team");
    }
}