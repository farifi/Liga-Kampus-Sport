<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Team" %>
<%@ page import="Model.Sport" %>
<%@ page import="Model.Competition" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !currentUser.isAdmin())) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    List<Team> registeredTeams = (List<Team>) request.getAttribute("teamList");
    List<Sport> sports = (List<Sport>) request.getAttribute("sports");
    List<Competition> competitions = (List<Competition>) request.getAttribute("competitions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/teamsCSS.css">
    <title>Teams &amp; Coaches - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="teams" class="section">
    <h2>Teams &amp; Coaches</h2>
    <p class="hint section-lead">Register faculty teams and assign coaches.</p>

    <div class="dashboard-stack">
        <div class="card card--tinted">
            <h3>Add New Team</h3>
            <form action="${pageContext.request.contextPath}/admin/team" method="POST">
                <div class="two-column-layout">
                    <div class="form-group">
                        <label for="team-sport">Sport</label>
                        <select id="team-sport" name="sportId" required>
                            <% if (sports != null) { for (Sport s : sports) { %>
                            <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="team-competition">Competition</label>
                        <select id="team-competition" name="competitionId" required>
                            <% if (competitions != null) { for (Competition c : competitions) { %>
                            <option value="<%= c.getCompetitionId() %>"><%= c.getCompetitionName() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="team-name">Team Display Name</label>
                        <input id="team-name" name="teamName" type="text" placeholder="e.g. FSKM" required>
                    </div>
                    <div class="form-group">
                        <label for="team-coach">Coach Name</label>
                        <input id="team-coach" name="coachName" type="text" placeholder="e.g. Assoc. Prof. Rahman">
                    </div>
                    <div class="form-group">
                        <label for="team-faculty">Faculty</label>
                        <input id="team-faculty" name="faculty" type="text" placeholder="e.g. FSKM">
                    </div>
                </div>

                <button type="submit" class="btn btn--primary" style="margin-top:6px;">Save Team</button>
            </form>
        </div>

        <div class="card large card--tinted">
            <h3>Team Registration Table</h3>
            <div class="table-scroll">
                <table class="data-table">
                    <thead>
                        <tr><th>#</th><th>Team</th><th>Faculty</th><th>Coach</th><th>Sport</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% if (registeredTeams != null && !registeredTeams.isEmpty()) {
                            for (Team team : registeredTeams) {
                        %>
                        <tr>
                            <td><%= team.getTeamId() %></td>
                            <td><strong><%= team.getTeamName() %></strong></td>
                            <td><%= team.getFaculty() != null ? team.getFaculty() : "Unassigned" %></td>
                            <td><%= team.getCoachName() != null ? team.getCoachName() : "Unassigned" %></td>
                            <td><span class="badge"><%= team.getSport() != null ? team.getSport().getSportName() : "-" %></span></td>
                            <td><span class="badge badge--success">Active</span></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="empty-state">No teams registered yet.</td></tr>
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
