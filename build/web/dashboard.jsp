<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Sport" %>
<%@ page import="Model.Competition" %>
<%@ page import="Model.Match" %>
<%@ page import="Model.TeamStatistic" %>
<%@ page import="Util.PointsCalculator" %>
<%
    List<Sport> sports = (List<Sport>) request.getAttribute("sports");
    if (sports == null) { response.sendRedirect(request.getContextPath() + "/dashboard"); return; }

    List<Competition> competitions = (List<Competition>) request.getAttribute("competitions");
    if (competitions == null) { competitions = java.util.Collections.emptyList(); }

    Competition selectedCompetition = (Competition) request.getAttribute("selectedCompetition");

    List<Match> matches = (List<Match>) request.getAttribute("matches");
    if (matches == null) { matches = java.util.Collections.emptyList(); }

    List<TeamStatistic> standings = (List<TeamStatistic>) request.getAttribute("standings");
    if (standings == null) { standings = java.util.Collections.emptyList(); }

    List<Object[]> topScorers = (List<Object[]>) request.getAttribute("topScorers");
    if (topScorers == null) { topScorers = java.util.Collections.emptyList(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/dashboardCSS.css">
    <title>Dashboard - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="dashboard" class="section">
    <h2>Dashboard</h2>
    <p class="hint section-lead">Live standings, top scorers, and upcoming fixtures at a glance.</p>

    <div class="dashboard-stack">
        <div class="card card--tinted dashboard-toolbar">
            <form action="${pageContext.request.contextPath}/dashboard" method="GET" class="dashboard-toolbar__row--filters">
                <div class="dashboard-toolbar__field">
                    <label class="dashboard-toolbar__label" for="dash-sport">Sport</label>
                    <select id="dash-sport" name="sportId" onchange="this.form.submit()">
                        <% for (Sport sport : sports) {
                            boolean isSelected = selectedCompetition != null && selectedCompetition.getSport() != null
                                    && selectedCompetition.getSport().getSportId() == sport.getSportId();
                        %>
                        <option value="<%= sport.getSportId() %>" <%= isSelected ? "selected" : "" %>><%= sport.getSportName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="dashboard-toolbar__field">
                    <label class="dashboard-toolbar__label" for="dash-competition">Competition</label>
                    <select id="dash-competition" name="competitionId" onchange="this.form.submit()">
                        <% for (Competition competition : competitions) {
                            boolean isSelected = selectedCompetition != null && selectedCompetition.getCompetitionId() == competition.getCompetitionId();
                        %>
                        <option value="<%= competition.getCompetitionId() %>" <%= isSelected ? "selected" : "" %>><%= competition.getCompetitionName() %></option>
                        <% } %>
                    </select>
                </div>
            </form>
            <p class="dashboard-toolbar__hint hint">Select a sport and competition to filter everything below.</p>
        </div>

        <div class="dashboard-columns">
            <div class="card card--accent-top card--tinted">
                <h3>Inter-Faculty Standings</h3>
                <table class="data-table data-table--compact">
                    <thead><tr><th>#</th><th>Team</th><th>Pts</th></tr></thead>
                    <tbody>
                        <% if (!standings.isEmpty()) {
                            int rank = 1;
                            for (TeamStatistic stat : standings) {
                                if (rank > 5) break;
                                String sn = (stat.getTeam() != null && stat.getTeam().getSport() != null) ? stat.getTeam().getSport().getSportName() : null;
                                int pts = PointsCalculator.calculatePoints(sn, stat.getWins(), stat.getDraws());
                                String rankClass = rank <= 3 ? "rank-cell rank-cell--" + rank : "rank-cell";
                        %>
                        <tr>
                            <td><span class="<%= rankClass %>"><%= rank %></span></td>
                            <td><%= stat.getTeam() != null ? stat.getTeam().getTeamName() : "-" %></td>
                            <td><strong><%= pts %></strong></td>
                        </tr>
                        <% rank++; } } else { %>
                        <tr><td colspan="3" class="empty-state">No standings yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <button type="button" class="btn btn--sm btn--ghost" style="margin-top:16px"
                        onclick="window.location.href='${pageContext.request.contextPath}/league'">View Full Table</button>
            </div>

            <div class="card card--purple card--tinted">
                <h3>Top Scorers</h3>
                <table class="data-table data-table--compact">
                    <thead><tr><th>Player</th><th>Team</th><th>Goals</th></tr></thead>
                    <tbody>
                        <% if (!topScorers.isEmpty()) {
                            for (Object[] row : topScorers) {
                        %>
                        <tr><td><%= row[0] %></td><td><%= row[1] %></td><td><strong><%= row[2] %></strong></td></tr>
                        <% } } else { %>
                        <tr><td colspan="3" class="empty-state">No goals recorded yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card large card--tinted">
            <h3><%= selectedCompetition != null ? selectedCompetition.getCompetitionName() : "Fixtures" %></h3>
            <p class="hint" style="margin-bottom:14px">Upcoming and recent matches for this competition.</p>

            <ul class="dash-matches-list">
                <% if (matches.isEmpty()) { %>
                    <li class="empty-state list-empty">No matches scheduled yet for this selection.</li>
                <% } else {
                    for (Match match : matches) {
                        boolean isCompleted = "COMPLETED".equalsIgnoreCase(match.getStatus());
                %>
                <li class="dash-match-card">
                    <div class="matches-list__when"><%= match.getDate() %> &middot; <%= match.getVenue() %></div>
                    <div class="matches-list__main">
                        <span class="matches-list__team"><%= match.getTeam1() != null ? match.getTeam1().getTeamName() : "TBD" %></span>
                        <span class="matches-list__score">
                            <% if (isCompleted) { %><%= match.getScore1() %> &ndash; <%= match.getScore2() %><% } else { %>VS<% } %>
                        </span>
                        <span class="matches-list__team"><%= match.getTeam2() != null ? match.getTeam2().getTeamName() : "TBD" %></span>
                    </div>
                    <div class="matches-list__meta">
                        <span class="status-pill <%= isCompleted ? "status-pill--done" : "status-pill--live" %>"><%= match.getStatus() %></span>
                        <button type="button" class="btn btn--sm btn--ghost" onclick="window.location.href='${pageContext.request.contextPath}/matches'">Open Match Center</button>
                    </div>
                </li>
                <% } } %>
            </ul>
        </div>
    </div>
</section>
</main>
</body>
</html>
