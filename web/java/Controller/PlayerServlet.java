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

        return teams.isEmpty() ? null : teams.get(0);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PlayerDAO playerDAO = new PlayerDAO();
        String action = request.getParameter("action");
        String teamIdParam = request.getParameter("teamId");
        if ("create".equalsIgnoreCase(action)) {
            String playerName = request.getParameter("playerName");
            String studentId = request.getParameter("studentId");
            String jerseyNoParam = request.getParameter("jerseyNo");
            String position = request.getParameter("position");
            if (teamIdParam != null && playerName != null && !playerName.isBlank()) {
                int teamId = Integer.parseInt(teamIdParam);
                int jerseyNo = 0;
                if (jerseyNoParam != null && !jerseyNoParam.isBlank()) {
                    jerseyNo = Integer.parseInt(jerseyNoParam);
                }
                Team team = new Team();
                team.setTeamId(teamId);
                Player player = new Player();
                player.setTeam(team);
                player.setPlayerName(playerName);
                player.setStudentId(studentId);
                player.setJerseyNo(jerseyNo);
                player.setPosition(position);
                playerDAO.insertPlayer(player);
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String playerIdParam = request.getParameter("playerId");
            String playerName = request.getParameter("playerName");
            String studentId = request.getParameter("studentId");
            String jerseyNoParam = request.getParameter("jerseyNo");
            String position = request.getParameter("position");
            if (playerIdParam != null && playerName != null && !playerName.isBlank()) {
                int playerId = Integer.parseInt(playerIdParam);
                int jerseyNo = 0;
                if (jerseyNoParam != null && !jerseyNoParam.isBlank()) {
                    jerseyNo = Integer.parseInt(jerseyNoParam);
                }
                Player player = new Player();
                player.setPlayerId(playerId);
                player.setPlayerName(playerName);
                player.setStudentId(studentId);
                player.setJerseyNo(jerseyNo);
                player.setPosition(position);
                playerDAO.updatePlayer(player);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String playerIdParam = request.getParameter("playerId");
            if (playerIdParam != null) {
                int playerId = Integer.parseInt(playerIdParam);
                playerDAO.deletePlayer(playerId);
            }
        }
        response.sendRedirect(request.getContextPath() + "/manager/players?teamId=" + (teamIdParam != null ? teamIdParam : ""));
    }
}