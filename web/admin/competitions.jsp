<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Competition" %>
<%@ page import="Model.Sport" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !currentUser.isAdmin())) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    List<Competition> competitionList = (List<Competition>) request.getAttribute("competitionList");
    List<Sport> sports = (List<Sport>) request.getAttribute("sports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/competitionCSS.css">
    <title>Competition Management - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="competitions" class="section">
    <h2>Competition Management</h2>
    <p class="hint section-lead">Create seasons, leagues, and knockout stages per sport.</p>

    <div class="dashboard-stack">
        <div class="management-card">
            <header class="management-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                <h2>Registered Competitions</h2>
                <button type="button" class="btn btn--sm btn--primary" onclick="openAddModal()">Add Competition</button>
            </header>

            <div class="table-responsive">
                <table class="management-table">
                    <thead>
                        <tr><th>#</th><th>Competition</th><th>Sport</th><th>Format</th><th>Status</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% if (competitionList != null && !competitionList.isEmpty()) {
                            for (Competition c : competitionList) {
                        %>
                        <tr>
                            <td class="font-bold">#<%= c.getCompetitionId() %></td>
                            <td><%= c.getCompetitionName() %></td>
                            <td><span class="badge"><%= c.getSport() != null ? c.getSport().getSportName() : "-" %></span></td>
                            <td><%= c.getFormat() != null ? c.getFormat() : "-" %></td>
                            <td><span class="status-pill"><%= c.getStatus() != null ? c.getStatus() : "-" %></span></td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn--sm btn--ghost" onclick="openEditModal(<%= c.getCompetitionId() %>, <%= c.getSport() != null ? c.getSport().getSportId() : 0 %>, '<%= c.getCompetitionName().replace("'", "\\'") %>', '<%= c.getFormat() != null ? c.getFormat().replace("'", "\\'") : "" %>', '<%= c.getStatus() != null ? c.getStatus().replace("'", "\\'") : "" %>')">Edit</button>
                                <form action="${pageContext.request.contextPath}/admin/competition" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="competitionId" value="<%= c.getCompetitionId() %>">
                                    <button type="submit" class="btn-withdraw" onclick="return confirm('Delete this competition?');">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-muted" style="text-align:center; padding:26px;">No competitions registered yet.</td></tr>
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
        <h3>Add New Competition</h3>
        <form action="${pageContext.request.contextPath}/admin/competition" method="POST">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label for="comp-sport">Sport</label>
                <select id="comp-sport" name="sportId" required>
                    <% if (sports != null) { for (Sport s : sports) { %>
                    <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="comp-name">Competition Name</label>
                <input id="comp-name" name="competitionName" type="text" placeholder="e.g. SUKMA Football League" required>
            </div>
            <div class="form-group">
                <label for="comp-format">Format</label>
                <input id="comp-format" name="format" type="text" placeholder="e.g. Round Robin, Knockout">
            </div>
            <div class="form-group">
                <label for="comp-status">Status</label>
                <select id="comp-status" name="status">
                    <option value="UPCOMING">Upcoming</option>
                    <option value="ONGOING">Ongoing</option>
                    <option value="COMPLETED">Completed</option>
                </select>
            </div>
            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Save Competition</button>
        </form>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        <h3>Edit Competition Info</h3>
        <form action="${pageContext.request.contextPath}/admin/competition" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="competitionId" id="edit-competitionId">
            <div class="form-group">
                <label for="edit-comp-sport">Sport</label>
                <select id="edit-comp-sport" name="sportId" required>
                    <% if (sports != null) { for (Sport s : sports) { %>
                    <option value="<%= s.getSportId() %>"><%= s.getSportName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="edit-comp-name">Competition Name</label>
                <input id="edit-comp-name" name="competitionName" type="text" required>
            </div>
            <div class="form-group">
                <label for="edit-comp-format">Format</label>
                <input id="edit-comp-format" name="format" type="text">
            </div>
            <div class="form-group">
                <label for="edit-comp-status">Status</label>
                <select id="edit-comp-status" name="status">
                    <option value="UPCOMING">Upcoming</option>
                    <option value="ONGOING">Ongoing</option>
                    <option value="COMPLETED">Completed</option>
                </select>
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
    function openEditModal(id, sportId, name, format, status) {
        document.getElementById("edit-competitionId").value = id;
        document.getElementById("edit-comp-sport").value = sportId;
        document.getElementById("edit-comp-name").value = name;
        document.getElementById("edit-comp-format").value = format;
        document.getElementById("edit-comp-status").value = status;
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
