<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Competition" %>
<%@ page import="Model.TeamStatistic" %>
<%@ page import="Util.PointsCalculator" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/leagueCSS.css">
    <title>League Standings - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<%
    List<Competition> competitions = (List<Competition>) request.getAttribute("competitions");
    Competition selectedCompetition = (Competition) request.getAttribute("selectedCompetition");
    List<TeamStatistic> standings = (List<TeamStatistic>) request.getAttribute("standings");
%>

<section id="analytics" class="section">
    <h2>League Standings</h2>
    <p class="hint section-lead">Points table for the selected competition, ranked by performance.</p>

    <form action="${pageContext.request.contextPath}/league" method="GET" class="card card--tinted" style="margin-bottom:22px;">
        <div class="dashboard-toolbar__field" style="max-width:380px;">
            <label for="league-competition">Competition</label>
            <select id="league-competition" name="competitionId" onchange="this.form.submit()">
                <% if (competitions != null) {
                    for (Competition comp : competitions) {
                        boolean isSelected = (selectedCompetition != null) && (selectedCompetition.getCompetitionId() == comp.getCompetitionId());
                %>
                <option value="<%= comp.getCompetitionId() %>" <%= isSelected ? "selected" : "" %>>
                    <%= comp.getCompetitionName() %> (<%= comp.getSport() != null ? comp.getSport().getSportName() : "" %>)
                </option>
                <% } } %>
            </select>
        </div>
    </form>

    <div class="standings-stack">
        <div class="card card--tinted">
            <h3><%= selectedCompetition != null ? selectedCompetition.getCompetitionName() : "No competition selected" %></h3>

            <div class="table-scroll">
                <table class="data-table league-table">
                    <thead>
                        <tr>
                            <th>#</th><th>Team</th><th title="Played">P</th><th title="Won">W</th>
                            <th title="Drawn">D</th><th title="Lost">L</th><th title="Points">Pts</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (standings == null || standings.isEmpty()) { %>
                            <tr><td colspan="7" class="empty-state">No stats recorded yet for this competition.</td></tr>
                        <% } else {
                            int rank = 1;
                            for (TeamStatistic stat : standings) {
                                String rowSportName = (stat.getTeam() != null && stat.getTeam().getSport() != null) ? stat.getTeam().getSport().getSportName() : null;
                                int points = PointsCalculator.calculatePoints(rowSportName, stat.getWins(), stat.getDraws());
                                String rowClass = rank <= 3 ? "league-table__row--top" : "";
                                String rankClass = rank <= 3 ? "rank-cell rank-cell--" + rank : "rank-cell";
                        %>
                        <tr class="<%= rowClass %>">
                            <td><span class="<%= rankClass %>"><%= rank %></span></td>
                            <td><strong><%= stat.getTeam() != null ? stat.getTeam().getTeamName() : "Unknown" %></strong></td>
                            <td><%= stat.getGamesPlayed() %></td>
                            <td><%= stat.getWins() %></td>
                            <td><%= stat.getDraws() %></td>
                            <td><%= stat.getLosses() %></td>
                            <td><strong><%= points %></strong></td>
                        </tr>
                        <% rank++; } } %>
                    </tbody>
                </table>
            </div>

            <div class="league-legend">
                <span><strong>P</strong> Played</span>
                <span><strong>W</strong> Won</span>
                <span><strong>D</strong> Drawn</span>
                <span><strong>L</strong> Lost</span>
                <span><strong>Pts</strong> Points</span>
            </div>
        </div>
    </div>
</section>
</main>
</body>
</html>
