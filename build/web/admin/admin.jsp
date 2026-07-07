<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="DAO.TeamDAO" %>
<%@ page import="DAO.SportDAO" %>
<%@ page import="DAO.CompetitionDAO" %>
<%@ page import="DAO.MatchDAO" %>
<%@ page import="DAO.PlayerDAO" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !currentUser.isAdmin())) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    int teamCount = new TeamDAO().selectAllTeams().size();
    int sportCount = new SportDAO().selectAllSports().size();
    int playerCount = new PlayerDAO().countAllPlayers();
    int matchCount = new MatchDAO().selectAllMatches().size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <title>Admin Dashboard - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section class="admin-page section">
    <div class="page-header simple">
        <h1>Admin Dashboard</h1>
        <p>Manage competitions, teams, and the sports catalogue for LIGA-KAMPUS.</p>
    </div>

    <div class="admin-hero">
        <div class="stat-tile"><div class="stat-value"><%= teamCount %></div><div class="stat-label">Active Teams</div></div>
        <div class="stat-tile"><div class="stat-value"><%= sportCount %></div><div class="stat-label">Sports Configured</div></div>
        <div class="stat-tile"><div class="stat-value"><%= playerCount %></div><div class="stat-label">Registered Players</div></div>
        <div class="stat-tile"><div class="stat-value"><%= matchCount %></div><div class="stat-label">Total Matches</div></div>
    </div>

    <div class="admin-grid">
        <div class="admin-tile">
            <div class="admin-icon purple">&#127942;</div>
            <h3>Competition Management</h3>
            <p>Create seasons, leagues, knockout brackets, and manage competition status.</p>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/admin/competition" class="btn btn--primary">Manage Competitions</a>
            </div>
        </div>

        <div class="admin-tile">
            <div class="admin-icon gold">&#9881;</div>
            <h3>Sports Catalogue &amp; Teams</h3>
            <p>Register faculty teams, assign coaches, and configure sports.</p>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/admin/team" class="btn btn--gold">Manage Teams</a>
            </div>
        </div>

        <div class="admin-tile">
            <div class="admin-icon navy">&#9917;</div>
            <h3>Match Center</h3>
            <p>Schedule fixtures and record results &mdash; standings update automatically.</p>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/matches" class="btn btn--ghost">Open Match Center</a>
            </div>
        </div>
    </div>
</section>
</main>
</body>
</html>
