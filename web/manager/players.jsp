<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Player" %>
<%@ page import="Model.Team" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !"MANAGER".equals(userRole))) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    List<Team> teams = (List<Team>) request.getAttribute("teams");
    List<Player> teamRoster = (List<Player>) request.getAttribute("playerRosterList");
    Team currentTeamContext = (Team) request.getAttribute("selectedTeamContext");
    int currentTeamId = (currentTeamContext != null) ? currentTeamContext.getTeamId() : 0;
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

    <div class="dashboard-stack">
        <div class="card card--tinted">
            <h3>Register New Player</h3>
            <form action="${pageContext.request.contextPath}/manager/players" method="POST">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="teamId" value="<%= currentTeamId %>">

                <div class="player-form">
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
                </div>

                <button type="submit" class="btn btn--primary" <%= currentTeamId == 0 ? "disabled" : "" %>>Add Player</button>
            </form>
        </div>

        <div class="card large card--tinted sport-block">
            <div class="sport-block__head">
                <h3><%= currentTeamContext != null ? currentTeamContext.getTeamName() : "Roster" %></h3>
                <% if (teamRoster != null) { %>
                <span class="badge"><%= teamRoster.size() %> player<%= teamRoster.size() == 1 ? "" : "s" %></span>
                <% } %>
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
                            <td><strong><%= player.getPlayerName() %></strong></td>
                            <td><%= player.getStudentId() %></td>
                            <td><%= player.getJerseyNo() %></td>
                            <td><%= player.getPosition() %></td>
                            <td class="inline-actions">
                                <form action="${pageContext.request.contextPath}/manager/players" method="POST">
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
</body>
</html>
