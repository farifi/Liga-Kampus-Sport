package Controller;

import Model.Player;
import Model.Team;
import Model.User;
import DAO.PlayerDAO;
import DAO.TeamDAO;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "playerServlet", urlPatterns = {"/manager/players"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB max player photo
public class PlayerServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images/players";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);
        String role = getRole(request);
        if (!isAuthorized(currentUser, role)) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        TeamDAO teamDAO = new TeamDAO();
        PlayerDAO playerDAO = new PlayerDAO();

        // Admins can manage any team's roster; team managers only ever see their own team(s).
        List<Team> teams = isAdmin(role, currentUser)
                ? teamDAO.selectAllTeams()
                : teamDAO.selectTeamsByManager(currentUser.getUserId());

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

        // Falls back to the first team the current user is actually allowed to manage,
        // never to some other team that wasn't in their own list.
        return teams.isEmpty() ? null : teams.get(0);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);
        String role = getRole(request);
        if (!isAuthorized(currentUser, role)) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        boolean admin = isAdmin(role, currentUser);
        PlayerDAO playerDAO = new PlayerDAO();
        TeamDAO teamDAO = new TeamDAO();
        String action = request.getParameter("action");
        String teamIdParam = request.getParameter("teamId");

        if ("create".equalsIgnoreCase(action)) {
            String playerName = request.getParameter("playerName");
            String studentId = request.getParameter("studentId");
            String jerseyNoParam = request.getParameter("jerseyNo");
            String position = request.getParameter("position");
            if (teamIdParam != null && playerName != null && !playerName.isBlank()) {
                try {
                    int teamId = Integer.parseInt(teamIdParam);

                    if (!admin && !teamOwnedBy(teamDAO, teamId, currentUser.getUserId())) {
                        response.sendRedirect(request.getContextPath() + "/manager/players?error=forbidden");
                        return;
                    }

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
                    player.setPlayerImage(storeUploadedImage(request, "playerImage"));
                    playerDAO.insertPlayer(player);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String playerIdParam = request.getParameter("playerId");
            String playerName = request.getParameter("playerName");
            String studentId = request.getParameter("studentId");
            String jerseyNoParam = request.getParameter("jerseyNo");
            String position = request.getParameter("position");
            if (playerIdParam != null && playerName != null && !playerName.isBlank()) {
                try {
                    int playerId = Integer.parseInt(playerIdParam);

                    // Always trust the DB, not the hidden form field, to find which team
                    // this player actually belongs to before allowing the edit.
                    int actualTeamId = playerDAO.selectTeamIdForPlayer(playerId);
                    if (actualTeamId == -1) {
                        response.sendRedirect(request.getContextPath() + "/manager/players?error=notfound");
                        return;
                    }
                    if (!admin && !teamOwnedBy(teamDAO, actualTeamId, currentUser.getUserId())) {
                        response.sendRedirect(request.getContextPath() + "/manager/players?error=forbidden");
                        return;
                    }

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

                    String newImage = storeUploadedImage(request, "playerImage");
                    if (newImage != null) {
                        player.setPlayerImage(newImage);
                    } else {
                        String existingImage = request.getParameter("existingPlayerImage");
                        player.setPlayerImage(existingImage != null && !existingImage.isBlank()
                                ? existingImage
                                : playerDAO.selectPlayerImage(playerId));
                    }

                    playerDAO.updatePlayer(player);
                    teamIdParam = String.valueOf(actualTeamId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String playerIdParam = request.getParameter("playerId");
            if (playerIdParam != null) {
                try {
                    int playerId = Integer.parseInt(playerIdParam);
                    int actualTeamId = playerDAO.selectTeamIdForPlayer(playerId);
                    if (actualTeamId == -1) {
                        response.sendRedirect(request.getContextPath() + "/manager/players?error=notfound");
                        return;
                    }
                    if (!admin && !teamOwnedBy(teamDAO, actualTeamId, currentUser.getUserId())) {
                        response.sendRedirect(request.getContextPath() + "/manager/players?error=forbidden");
                        return;
                    }
                    playerDAO.deletePlayer(playerId);
                    teamIdParam = String.valueOf(actualTeamId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/manager/players?teamId=" + (teamIdParam != null ? teamIdParam : ""));
    }

    private boolean teamOwnedBy(TeamDAO teamDAO, int teamId, int managerUserId) {
        Team team = teamDAO.selectTeamById(teamId);
        return team != null && team.getManager() != null && team.getManager().getUserId() == managerUserId;
    }

    private String storeUploadedImage(HttpServletRequest request, String partName) throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        String extension = "";
        if (submittedFileName != null && submittedFileName.contains(".")) {
            extension = submittedFileName.substring(submittedFileName.lastIndexOf('.'));
        }
        String generatedName = UUID.randomUUID().toString() + extension;

        String realUploadDir = getServletContext().getRealPath("/" + UPLOAD_DIR);
        File uploadDirFile = new File(realUploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        File targetFile = new File(uploadDirFile, generatedName);
        try (InputStream in = filePart.getInputStream();
             OutputStream out = Files.newOutputStream(targetFile.toPath())) {
            in.transferTo(out);
        }

        return UPLOAD_DIR + "/" + generatedName;
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (User) session.getAttribute("user") : null;
    }

    private String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (String) session.getAttribute("role") : null;
    }

    private boolean isAdmin(String role, User currentUser) {
        return "ADMIN".equalsIgnoreCase(role) || (currentUser != null && currentUser.isAdmin());
    }

    private boolean isAuthorized(User currentUser, String role) {
        if (currentUser == null) return false;
        return "ADMIN".equalsIgnoreCase(role) || "MANAGER".equalsIgnoreCase(role) || "TEAM_MANAGER".equalsIgnoreCase(role);
    }
}