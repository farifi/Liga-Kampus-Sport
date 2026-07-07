package Controller;

import Model.Player;
import Model.Team;
import DAO.PlayerDAO;
import DAO.TeamDAO;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "playerServlet", urlPatterns = {"/manager/players"})
public class PlayerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TeamDAO teamDAO = new TeamDAO();
        PlayerDAO playerDAO = new PlayerDAO();

        List<Team> teams = teamDAO.selectAllTeams();
        Team selectedTeam = resolveSelectedTeam(request, teams);

        List<Player> playerRosterList = (selectedTeam != null)
                ? playerDAO.selectPlayersByTeam(selectedTeam.getTeamId())
                : Collections.emptyList();

        request.setAttribute("teams", teams);
        request.setAttribute("selectedTeamContext", selectedTeam);
        request.setAttribute("playerRosterList", playerRosterList);

        request.getRequestDispatcher("/manager/players.jsp").forward(request, response);
    }

    private Team resolveSelectedTeam(HttpServletRequest request, List<Team> teams) {
        String teamIdParam = request.getParameter("teamId");

        if (teamIdParam != null && !teamIdParam.isBlank()) {
            try {
                int teamId = Integer.parseInt(teamIdParam);
                for (Team team : teams) {
                    if (team.getTeamId() == teamId) {
                        return team;
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }

        // Default fallback: first team in the list, if any
        return teams.isEmpty() ? null : teams.get(0);
    }
}