<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Sport" %>
<%@ page import="Model.Competition" %>
<%@ page import="Model.Match" %>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/matchesCSS.css">
    <title>Match Center - LIGA-KAMPUS</title>
    <script>
        function togglePanel(matchId) {
            var panel = document.getElementById("panel-" + matchId);
            panel.hidden = !panel.hidden;
        }
    </script>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<%
    // Only admins are allowed to edit match results — everyone else gets a read-only view.
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
    boolean isAdmin = currentUser != null && ("ADMIN".equals(userRole) || currentUser.isAdmin());
%>

<section class="section">
    <h2>Match Center</h2>
    <p class="hint section-lead">Schedules, live scores, and results across every competition.</p>

    <%
        List<Sport> sports = (List<Sport>) request.getAttribute("sports");
        List<Competition> competitions = (List<Competition>) request.getAttribute("competitions");
        List<Match> matches = (List<Match>) request.getAttribute("matches");

        Object rawSportId = request.getAttribute("selectedSportId");
        String selectedSportId = (rawSportId != null) ? String.valueOf(rawSportId) : "";
        Object rawCompId = request.getAttribute("selectedCompetitionId");
        String selectedCompetitionId = (rawCompId != null) ? String.valueOf(rawCompId) : "";
    %>

    <form action="${pageContext.request.contextPath}/matches" method="GET" class="card card--tinted matches-toolbar" style="margin-bottom:22px;">
        <div class="matches-toolbar__field">
            <label for="sportId">Sport</label>
            <select name="sportId" id="sportId" onchange="this.form.submit()">
                <option value="all">All Sports</option>
                <% if (sports != null) {
                    for (Sport s : sports) {
                        String selected = String.valueOf(s.getSportId()).equals(selectedSportId) ? "selected" : "";
                %>
                <option value="<%= s.getSportId() %>" <%= selected %>><%= s.getSportName() %></option>
                <% } } %>
            </select>
        </div>

        <div class="matches-toolbar__field matches-toolbar__field--grow">
            <label for="competitionId">Competition</label>
            <select name="competitionId" id="competitionId" onchange="this.form.submit()">
                <option value="all">All Competitions</option>
                <% if (competitions != null) {
                    for (Competition c : competitions) {
                        String selected = String.valueOf(c.getCompetitionId()).equals(selectedCompetitionId) ? "selected" : "";
                %>
                <option value="<%= c.getCompetitionId() %>" <%= selected %>>
                    <%= c.getCompetitionName() %> (<%= c.getSport() != null ? c.getSport().getSportName() : "" %>)
                </option>
                <% } } %>
            </select>
        </div>
    </form>

    <ul class="matches-list">
        <% if (matches != null && !matches.isEmpty()) {
            for (Match match : matches) {
                boolean isCompleted = "COMPLETED".equalsIgnoreCase(match.getStatus());
                String pillClass = isCompleted ? "status-pill--done" : "status-pill--live";
        %>
        <li class="matches-list__item">
            <div class="matches-list__when"><%= match.getDate() %><br><%= match.getVenue() %></div>

            <div>
                <div class="matches-list__main">
                    <span class="matches-list__team"><%= match.getTeam1() != null ? match.getTeam1().getTeamName() : "TBD" %></span>
                    <span class="matches-list__score">
                        <% if (isCompleted) { %><%= match.getScore1() %> &ndash; <%= match.getScore2() %><% } else { %>VS<% } %>
                    </span>
                    <span class="matches-list__team"><%= match.getTeam2() != null ? match.getTeam2().getTeamName() : "TBD" %></span>
                </div>
                <div class="matches-list__meta">
                    <span class="badge"><%= match.getSport() != null ? match.getSport().getSportName() : "" %></span>
                    <span class="matches-list__round"><%= match.getCompetition() != null ? match.getCompetition().getCompetitionName() : "" %></span>
                    <span class="status-pill <%= pillClass %>"><%= match.getStatus() %></span>
                </div>
            </div>

            <% if (isAdmin) { %>
            <button type="button" class="btn btn--sm btn--ghost matches-list__open" onclick="togglePanel(<%= match.getMatchId() %>)">Edit Result</button>
            <% } %>
        </li>

        <% if (isAdmin) { %>
        <li id="panel-<%= match.getMatchId() %>" hidden>
            <form action="${pageContext.request.contextPath}/matches" method="POST" class="card card--tinted match-edit-panel">
                <input type="hidden" name="matchId" value="<%= match.getMatchId() %>">
                <div class="form-group">
                    <label><%= match.getTeam1() != null ? match.getTeam1().getTeamName() : "Team 1" %> Score</label>
                    <input type="number" name="score1" value="<%= match.getScore1() %>" min="0" required>
                </div>
                <div class="form-group">
                    <label><%= match.getTeam2() != null ? match.getTeam2().getTeamName() : "Team 2" %> Score</label>
                    <input type="number" name="score2" value="<%= match.getScore2() %>" min="0" required>
                </div>
                <div class="form-group" style="min-width:160px;">
                    <label>Status</label>
                    <select name="status">
                        <option value="SCHEDULED" <%= "SCHEDULED".equals(match.getStatus()) ? "selected" : "" %>>SCHEDULED</option>
                        <option value="COMPLETED" <%= "COMPLETED".equals(match.getStatus()) ? "selected" : "" %>>COMPLETED</option>
                    </select>
                </div>
                <button type="submit" class="btn btn--primary">Save Update</button>
            </form>
        </li>
        <% } %>
        <% } } else { %>
            <li class="matches-list-empty empty-state">No matches match your current filters.</li>
        <% } %>
    </ul>
</section>
</main>
</body>
</html>
