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
        <div class="card large card--tinted">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
                <h3 style="margin:0;">Team Registration Table</h3>
                <button type="button" class="btn btn--sm btn--primary" onclick="openAddModal()">Add Team</button>
            </div>
            <div class="table-scroll">
                <table class="data-table">
                    <thead>
                        <tr><th>#</th><th>Team</th><th>Faculty</th><th>Coach</th><th>Sport</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% if (registeredTeams != null && !registeredTeams.isEmpty()) {
                            for (Team team : registeredTeams) {
                        %>
                        <tr>
                            <td><%= team.getTeamId() %></td>
                            <td><strong><%= team.getTeamName() %></strong></td>
                            <td><%= team.getFaculty() != null ? team.getFaculty() : "-" %></td>
                            <td><%= team.getCoachName() != null ? team.getCoachName() : "-" %></td>
                            <td><span class="badge"><%= team.getSport() != null ? team.getSport().getSportName() : "-" %></span></td>
                            <td class="action-buttons" style="display:flex; gap:8px;">
                                <button type="button" class="btn btn--sm btn--ghost" onclick="openEditModal(<%= team.getTeamId() %>, <%= team.getSport() != null ? team.getSport().getSportId() : 0 %>, <%= team.getCompetition() != null ? team.getCompetition().getCompetitionId() : 0 %>, '<%= team.getTeamName().replace("'", "\\'") %>', '<%= team.getCoachName() != null ? team.getCoachName().replace("'", "\\'") : "" %>', '<%= team.getFaculty() != null ? team.getFaculty().replace("'", "\\'") : "" %>')">Edit</button>
                                <form action="${pageContext.request.contextPath}/admin/team" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="teamId" value="<%= team.getTeamId() %>">
                                    <button type="submit" class="btn btn--sm btn--danger" onclick="return confirm('Delete this team?');">Delete</button>
                                </form>
                            </td>
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

<div id="addModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeAddModal()">&times;</button>
        <h3>Add New Team</h3>
        <form action="${pageContext.request.contextPath}/admin/team" method="POST">
            <input type="hidden" name="action" value="create">
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
            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Save Team</button>
        </form>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        <h3>Edit Team Info</h3>
        <form action="${pageContext.request.contextPath}/admin/team" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="teamId" id="edit-teamId">
            <div class="form-group">
                <label for="edit-team-sport">Sport</label>
                <select id="edit-team-sport" name="sportId" required>
                    <% if (sports != null) { for (Sport s : sports) { %>
                    <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="edit-team-competition">Competition</label>
                <select id="edit-team-competition" name="competitionId" required>
                    <% if (competitions != null) { for (Competition c : competitions) { %>
                    <option value="<%= c.getCompetitionId() %>"><%= c.getCompetitionName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="edit-team-name">Team Display Name</label>
                <input id="edit-team-name" name="teamName" type="text" required>
            </div>
            <div class="form-group">
                <label for="edit-team-coach">Coach Name</label>
                <input id="edit-team-coach" name="coachName" type="text">
            </div>
            <div class="form-group">
                <label for="edit-team-faculty">Faculty</label>
                <input id="edit-team-faculty" name="faculty" type="text">
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
    function openEditModal(id, sportId, compId, name, coach, faculty) {
        document.getElementById("edit-teamId").value = id;
        document.getElementById("edit-team-sport").value = sportId;
        document.getElementById("edit-team-competition").value = compId;
        document.getElementById("edit-team-name").value = name;
        document.getElementById("edit-team-coach").value = coach;
        document.getElementById("edit-team-faculty").value = faculty;
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
