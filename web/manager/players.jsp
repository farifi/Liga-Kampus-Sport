<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Player" %>
<%@ page import="Model.Team" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equalsIgnoreCase(userRole) && !"MANAGER".equalsIgnoreCase(userRole) && !"TEAM_MANAGER".equalsIgnoreCase(userRole))) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    boolean isAdminUser = "ADMIN".equalsIgnoreCase(userRole) || currentUser.isAdmin();

    List<Team> teams = (List<Team>) request.getAttribute("teams");
    List<Player> teamRoster = (List<Player>) request.getAttribute("playerRosterList");
    Team currentTeamContext = (Team) request.getAttribute("selectedTeamContext");
    int currentTeamId = (currentTeamContext != null) ? currentTeamContext.getTeamId() : 0;

    // Managers only ever have their own team(s) in "teams" (enforced server-side),
    // so if they don't manage more than one team, there's nothing to actually choose from.
    boolean showTeamSelector = isAdminUser || (teams != null && teams.size() > 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/playersCSS.css">
    <title>Player Management - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="players" class="section">
    <h2>Player Management</h2>
    <p class="hint section-lead">Logged in as <strong><%= userRole %></strong> &mdash; register and manage your team roster.</p>

    <% if (showTeamSelector) { %>
    <form action="${pageContext.request.contextPath}/manager/players" method="GET" class="card card--tinted" style="margin-bottom:22px;">
        <div class="dashboard-toolbar__field" style="max-width:340px;">
            <label for="player-team">Team</label>
            <select id="player-team" name="teamId" onchange="this.form.submit()">
                <% if (teams != null) {
                    for (Team team : teams) {
                        boolean isSelected = currentTeamContext != null && currentTeamContext.getTeamId() == team.getTeamId();
                %>
                <option value="<%= team.getTeamId() %>" <%= isSelected ? "selected" : "" %>><%= team.getTeamName() %></option>
                <% } } %>
            </select>
        </div>
    </form>
    <% } else if (currentTeamContext != null) { %>
    <div class="card card--tinted" style="margin-bottom:22px; display:flex; align-items:center; gap:10px;">
        <span class="hint" style="margin:0;">Managing team:</span>
        <strong style="font-size:1.05rem;"><%= currentTeamContext.getTeamName() %></strong>
    </div>
    <% } else { %>
    <div class="card card--tinted" style="margin-bottom:22px;">
        <p class="hint" style="margin:0;">You haven't been assigned to manage any team yet. Contact an admin to get assigned.</p>
    </div>
    <% } %>

    <div class="dashboard-stack">
        <div class="card large card--tinted sport-block">
            <div class="sport-block__head">
                <h3><%= currentTeamContext != null ? currentTeamContext.getTeamName() : "Roster" %></h3>
                <div style="display:flex; gap:10px; align-items:center;">
                    <% if (teamRoster != null) { %>
                    <span class="badge"><%= teamRoster.size() %> player<%= teamRoster.size() == 1 ? "" : "s" %></span>
                    <% } %>
                    <button type="button" class="btn btn--sm btn--primary" onclick="openAddModal()" <%= currentTeamId == 0 ? "disabled" : "" %>>Add Player</button>
                </div>
            </div>

            <div class="table-scroll">
                <table class="data-table player-table">
                    <thead>
                        <tr><th>Name</th><th>Student ID</th><th>Jersey #</th><th>Position</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% if (teamRoster != null && !teamRoster.isEmpty()) {
                            for (Player player : teamRoster) {
                        %>
                        <tr>
                            <td style="display:flex; align-items:center; gap:12px;">
                                <% if (player.getPlayerImage() != null && !player.getPlayerImage().isBlank()) { %>
                                    <img src="${pageContext.request.contextPath}/<%= player.getPlayerImage() %>" style="width:36px; height:36px; border-radius:50%; object-fit:cover; border: 1px solid rgba(0,0,0,0.1);">
                                <% } else { %>
                                    <div style="width:36px; height:36px; border-radius:50%; background:#e2e8f0; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:14px; color:#4a5568;"><%= player.getPlayerName().length() > 0 ? player.getPlayerName().substring(0, 1).toUpperCase() : "?" %></div>
                                <% } %>
                                <strong><%= player.getPlayerName() %></strong>
                            </td>
                            <td><%= player.getStudentId() != null ? player.getStudentId() : "-" %></td>
                            <td><%= player.getJerseyNo() %></td>
                            <td><%= player.getPosition() != null && !player.getPosition().isBlank() ? player.getPosition() : "-" %></td>
                            <td class="inline-actions" style="display:flex; gap:8px; align-items:center;">
                                <button type="button" class="btn btn--sm btn--ghost" onclick="openEditModal(<%= player.getPlayerId() %>, '<%= player.getPlayerName().replace("'", "\\'") %>', '<%= player.getStudentId() != null ? player.getStudentId().replace("'", "\\'") : "" %>', <%= player.getJerseyNo() %>, '<%= player.getPosition() != null ? player.getPosition().replace("'", "\\'") : "" %>', '<%= player.getPlayerImage() != null ? player.getPlayerImage().replace("'", "\\'") : "" %>')">Edit</button>
                                <form action="${pageContext.request.contextPath}/manager/players" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="teamId" value="<%= currentTeamId %>">
                                    <input type="hidden" name="playerId" value="<%= player.getPlayerId() %>">
                                    <button type="submit" class="btn btn--sm btn--danger" onclick="return confirm('Remove this player?');">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" class="empty-state">No players registered for this team yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
</main>

<div id="addModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeAddModal()">&times;</button>
        <h3>Register New Player</h3>
        <form action="${pageContext.request.contextPath}/manager/players" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="create">
            <input type="hidden" name="teamId" value="<%= currentTeamId %>">
            <div class="form-group">
                <label>Player Name</label>
                <input type="text" name="playerName" placeholder="Full name" required>
            </div>
            <div class="form-group">
                <label>Student ID</label>
                <input type="text" name="studentId" placeholder="e.g. 2023123456">
            </div>
            <div class="form-group">
                <label>Jersey Number</label>
                <input type="number" name="jerseyNo" min="0">
            </div>
            <div class="form-group">
                <label>Position</label>
                <input type="text" name="position" placeholder="e.g. Striker">
            </div>
            <div class="form-group">
                <label>Player Photo</label>
                <input type="file" name="playerImage" accept="image/*">
            </div>
            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Add Player</button>
        </form>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        <h3>Edit Player Info</h3>
        <form action="${pageContext.request.contextPath}/manager/players" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="teamId" value="<%= currentTeamId %>">
            <input type="hidden" name="playerId" id="edit-playerId">
            <input type="hidden" name="existingPlayerImage" id="edit-existingPlayerImage">
            
            <div class="form-group" style="display: flex; gap: 15px; align-items: center; margin-bottom: 15px;">
                <div style="width: 50px; height: 50px; border-radius: 50%; overflow: hidden; background: #e2e8f0; border: 1px solid rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; flex-shrink:0;">
                    <span id="edit-image-placeholder" style="font-weight: bold; color: #718096; font-size:18px;">?</span>
                    <img id="edit-image-preview" src="" style="width: 100%; height: 100%; object-fit: cover; display: none;">
                </div>
                <div style="flex-grow: 1;">
                    <label style="margin-bottom:4px;">Change Player Photo</label>
                    <input type="file" name="playerImage" accept="image/*">
                </div>
            </div>
            
            <div class="form-group">
                <label>Player Name</label>
                <input type="text" name="playerName" id="edit-playerName" required>
            </div>
            <div class="form-group">
                <label>Student ID</label>
                <input type="text" name="studentId" id="edit-studentId">
            </div>
            <div class="form-group">
                <label>Jersey Number</label>
                <input type="number" name="jerseyNo" id="edit-jerseyNo" min="0">
            </div>
            <div class="form-group">
                <label>Position</label>
                <input type="text" name="position" id="edit-position">
            </div>
            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Save Changes</button>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById("addModal").classList.add("is-open");
    }
    function closeAddModal() {
        document.getElementById("addModal").classList.remove("is-open");
    }
    function openEditModal(id, name, studentId, jersey, pos, imagePath) {
        document.getElementById("edit-playerId").value = id;
        document.getElementById("edit-playerName").value = name;
        document.getElementById("edit-studentId").value = studentId;
        document.getElementById("edit-jerseyNo").value = jersey;
        document.getElementById("edit-position").value = pos;
        document.getElementById("edit-existingPlayerImage").value = imagePath;
        
        var imgPreview = document.getElementById("edit-image-preview");
        var placeholder = document.getElementById("edit-image-placeholder");
        if (imagePath && imagePath.trim() !== "") {
            imgPreview.src = "${pageContext.request.contextPath}/" + imagePath;
            imgPreview.style.display = "block";
            placeholder.style.display = "none";
        } else {
            imgPreview.src = "";
            imgPreview.style.display = "none";
            placeholder.innerText = name.length > 0 ? name.substring(0, 1).toUpperCase() : "?";
            placeholder.style.display = "block";
        }
        
        document.getElementById("editModal").classList.add("is-open");
    }
    function closeEditModal() {
        document.getElementById("editModal").classList.remove("is-open");
    }
    window.onclick = function(event) {
        var add = document.getElementById("addModal");
        var edit = document.getElementById("editModal");
        if (event.target == add) {
            closeAddModal();
        }
        if (event.target == edit) {
            closeEditModal();
        }
    }
</script>
</body>
</html>