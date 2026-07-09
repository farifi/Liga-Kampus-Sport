<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Match" %>
<%@ page import="Model.Sport" %>
<%@ page import="Model.Competition" %>
<%@ page import="Model.Team" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !currentUser.isAdmin())) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    List<Match> matches = (List<Match>) request.getAttribute("matches");
    List<Sport> sports = (List<Sport>) request.getAttribute("sports");
    List<Competition> competitions = (List<Competition>) request.getAttribute("competitions");
    List<Team> teams = (List<Team>) request.getAttribute("teams");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/competitionCSS.css">
    <title>Match Management - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="matches" class="section">
    <h2>Match Management</h2>
    <p class="hint section-lead">Schedule fixtures, record scores, and update match status.</p>

    <div class="dashboard-stack">
        <div class="management-card">
            <header class="management-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                <h2>Match Registry</h2>
                <button type="button" class="btn btn--sm btn--primary" onclick="openAddModal()">Add Match</button>
            </header>

            <div class="table-responsive">
                <table class="management-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Teams</th>
                            <th>Sport / Competition</th>
                            <th>Venue &amp; Date</th>
                            <th>Score</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (matches != null && !matches.isEmpty()) {
                            for (Match m : matches) {
                        %>
                        <tr>
                            <td class="font-bold">#<%= m.getMatchId() %></td>
                            <td>
                                <strong><%= m.getTeam1() != null ? m.getTeam1().getTeamName() : "-" %></strong>
                                <span class="text-muted">vs</span>
                                <strong><%= m.getTeam2() != null ? m.getTeam2().getTeamName() : "-" %></strong>
                            </td>
                            <td>
                                <span class="badge"><%= m.getSport() != null ? m.getSport().getSportName() : "-" %></span>
                                <span class="hint" style="display:block; margin:2px 0 0 0;"><%= m.getCompetition() != null ? m.getCompetition().getCompetitionName() : "-" %></span>
                            </td>
                            <td><%= m.getVenue() %><br><span class="text-muted" style="font-size:11.5px;"><%= m.getDate() %></span></td>
                            <td><strong><%= m.getScore1() %> - <%= m.getScore2() %></strong></td>
                            <td>
                                <span class="status-pill <%= "COMPLETED".equalsIgnoreCase(m.getStatus()) ? "status-pill--done" : "status-pill--live" %>">
                                    <%= m.getStatus() %>
                                </span>
                            </td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn--sm btn--ghost" onclick="openEditModal(<%= m.getMatchId() %>, <%= m.getSport() != null ? m.getSport().getSportId() : 0 %>, <%= m.getCompetition() != null ? m.getCompetition().getCompetitionId() : 0 %>, <%= m.getTeam1() != null ? m.getTeam1().getTeamId() : 0 %>, <%= m.getTeam2() != null ? m.getTeam2().getTeamId() : 0 %>, '<%= m.getVenue().replace("'", "\\'") %>', '<%= m.getDate() %>', <%= m.getScore1() %>, <%= m.getScore2() %>, '<%= m.getStatus() %>')">Edit</button>
                                <form action="${pageContext.request.contextPath}/admin/matches" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="matchId" value="<%= m.getMatchId() %>">
                                    <button type="submit" class="btn-withdraw" onclick="return confirm('Delete this match?');">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" class="text-muted" style="text-align:center; padding:26px;">No matches scheduled yet.</td></tr>
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
        <h3>Schedule Match</h3>
        <form action="${pageContext.request.contextPath}/admin/matches" method="POST">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label>Sport</label>
                <select name="sportId" required>
                    <% if (sports != null) { for (Sport s : sports) { %>
                    <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                    <% } } %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Competition</label>
                <select name="competitionId" required>
                    <% if (competitions != null) { for (Competition c : competitions) { %>
                    <option value="<%= c.getCompetitionId() %>"><%= c.getCompetitionName() %></option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Team 1</label>
                <select name="team1Id" required>
                    <% if (teams != null) { for (Team t : teams) { %>
                    <option value="<%= t.getTeamId() %>"><%= t.getTeamName() %> (<%= t.getSport() != null ? t.getSport().getSportName() : "" %>)</option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Team 2</label>
                <select name="team2Id" required>
                    <% if (teams != null) { for (Team t : teams) { %>
                    <option value="<%= t.getTeamId() %>"><%= t.getTeamName() %> (<%= t.getSport() != null ? t.getSport().getSportName() : "" %>)</option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Venue</label>
                <input type="text" name="venue" placeholder="e.g. Court A" required>
            </div>

            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" required>
            </div>

            <div class="form-group">
                <label>Score 1</label>
                <input type="number" name="score1" value="0" min="0">
            </div>

            <div class="form-group">
                <label>Score 2</label>
                <input type="number" name="score2" value="0" min="0">
            </div>

            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="SCHEDULED">SCHEDULED</option>
                    <option value="COMPLETED">COMPLETED</option>
                </select>
            </div>

            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Schedule Match</button>
        </form>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        <h3>Edit Match Fixture</h3>
        <form action="${pageContext.request.contextPath}/admin/matches" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="matchId" id="edit-matchId">
            
            <div class="form-group">
                <label>Sport</label>
                <select name="sportId" id="edit-sportId" required>
                    <% if (sports != null) { for (Sport s : sports) { %>
                    <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                    <% } } %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Competition</label>
                <select name="competitionId" id="edit-competitionId" required>
                    <% if (competitions != null) { for (Competition c : competitions) { %>
                    <option value="<%= c.getCompetitionId() %>"><%= c.getCompetitionName() %></option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Team 1</label>
                <select name="team1Id" id="edit-team1Id" required>
                    <% if (teams != null) { for (Team t : teams) { %>
                    <option value="<%= t.getTeamId() %>"><%= t.getTeamName() %> (<%= t.getSport() != null ? t.getSport().getSportName() : "" %>)</option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Team 2</label>
                <select name="team2Id" id="edit-team2Id" required>
                    <% if (teams != null) { for (Team t : teams) { %>
                    <option value="<%= t.getTeamId() %>"><%= t.getTeamName() %> (<%= t.getSport() != null ? t.getSport().getSportName() : "" %>)</option>
                    <% } } %>
                </select>
            </div>

            <div class="form-group">
                <label>Venue</label>
                <input type="text" name="venue" id="edit-venue" required>
            </div>

            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" id="edit-date" required>
            </div>

            <div class="form-group">
                <label>Score 1</label>
                <input type="number" name="score1" id="edit-score1" min="0">
            </div>

            <div class="form-group">
                <label>Score 2</label>
                <input type="number" name="score2" id="edit-score2" min="0">
            </div>

            <div class="form-group">
                <label>Status</label>
                <select name="status" id="edit-status">
                    <option value="SCHEDULED">SCHEDULED</option>
                    <option value="COMPLETED">COMPLETED</option>
                </select>
            </div>

            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Save Update</button>
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
    function openEditModal(id, sportId, compId, t1Id, t2Id, venue, date, score1, score2, status) {
        document.getElementById("edit-matchId").value = id;
        document.getElementById("edit-sportId").value = sportId;
        document.getElementById("edit-competitionId").value = compId;
        document.getElementById("edit-team1Id").value = t1Id;
        document.getElementById("edit-team2Id").value = t2Id;
        document.getElementById("edit-venue").value = venue;
        document.getElementById("edit-date").value = date;
        document.getElementById("edit-score1").value = score1;
        document.getElementById("edit-score2").value = score2;
        document.getElementById("edit-status").value = status;
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
