<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%@ page import="java.util.List" %>
<%
    // Ensure only authorized administrators can access this layout
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    if (currentUser == null || (!"ADMIN".equals(userRole) && !currentUser.isAdmin())) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }

    List<User> listUser = (List<User>) request.getAttribute("listUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/competitionCSS.css">
    <title>User Management - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="users" class="section">
    <h2>User Account Management</h2>
    <p class="hint section-lead">Create new system access profiles, change role levels, and delete old accounts.</p>

    <div class="dashboard-stack">
        <div class="management-card">
            <header class="management-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                <h2>Registered Accounts</h2>
                <button type="button" class="btn btn--sm btn--primary" onclick="openAddModal()">Add User Account</button>
            </header>

            <div class="table-responsive">
                <table class="management-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Faculty Mapping</th>
                            <th>System Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listUser != null && !listUser.isEmpty()) {
                            for (User u : listUser) {
                        %>
                        <tr>
                            <td class="font-bold">#<%= u.getUserId() %></td>
                            <td><strong><%= u.getFullName() %></strong></td>
                            <td><%= u.getEmail() %></td>
                            <td><span class="badge" style="background:#eaeaea; color:#333;"><%= u.getFaculty() != null ? u.getFaculty() : "—" %></span></td>
                            <td>
                                <span class="status-pill <%= "ADMIN".equalsIgnoreCase(u.getRole()) ? "status-pill--done" : "status-pill--live" %>">
                                    <%= u.getRole() %>
                                </span>
                            </td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn--sm btn--ghost" 
                                        onclick="openEditModal(<%= u.getUserId() %>, '<%= u.getFullName().replace("'", "\\'") %>', '<%= u.getEmail().replace("'", "\\'") %>', '<%= u.getFaculty() != null ? u.getFaculty().replace("'", "\\'") : "" %>', '<%= u.getRole() %>')">
                                    Edit
                                </button>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn-withdraw" onclick="return confirm('Permanently delete this user account?');">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-muted" style="text-align:center; padding:26px;">No registered user accounts found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>
</main>

<div id="addUserModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeAddModal()">&times;</button>
        <h3>Create New User Profile</h3>
        <form action="${pageContext.request.contextPath}/admin/users" method="POST">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" placeholder="e.g. Ahmad Dani" required>
            </div>
            
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="name@domain.com" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Create secure password" required>
            </div>

            <div class="form-group">
                <label for="add-faculty">Faculty</label>
                <select id="add-faculty" name="faculty" required style="width: 100%;">
                    <option value="">-- Select Faculty --</option>
                    <option value="FSKM">FSKM - Faculty of Computer and Mathematical Sciences</option>
                    <option value="FBM">FBM - Faculty of Business and Management</option>
                    <option value="FKE">FKE - Faculty of Electrical Engineering</option>
                    <option value="FKM">FKM - Faculty of Mechanical Engineering</option>
                    <option value="FKA">FKA - Faculty of Civil Engineering</option>
                    <option value="FSPU">FSPU - Faculty of Architecture, Planning and Surveying</option>
                    <option value="FSR">FSR - Faculty of Sports Science and Recreation</option>
                </select>
            </div>

            <div class="form-group">
                <label>System Role Mapping</label>
                <select name="role">
                    <option value="USER">USER</option>
                    <option value="TEAM_MANAGER">TEAM_MANAGER</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
            </div>

            <button type="submit" class="btn btn--primary" style="margin-top:16px; width: 100%;">Save Account Profile</button>
        </form>
    </div>
</div>

<div id="editUserModal" class="modal">
    <div class="modal-content">
        <button type="button" class="modal-close" onclick="closeEditModal()">&times;</button>
        <h3>Modify Profile Configuration</h3>
        <form action="${pageContext.request.contextPath}/admin/users" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" id="edit-userId">
            
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" id="edit-fullName" required>
            </div>
            
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" id="edit-email" required>
            </div>

            <div class="form-group">
                <label for="edit-faculty">Faculty</label>
                <select id="edit-faculty" name="faculty" required style="width: 100%;">
                    <option value="">-- Select Faculty --</option>
                    <option value="FSKM">FSKM - Faculty of Computer and Mathematical Sciences</option>
                    <option value="FBM">FBM - Faculty of Business and Management</option>
                    <option value="FKE">FKE - Faculty of Electrical Engineering</option>
                    <option value="FKM">FKM - Faculty of Mechanical Engineering</option>
                    <option value="FKA">FKA - Faculty of Civil Engineering</option>
                    <option value="FSPU">FSPU - Faculty of Architecture, Planning and Surveying</option>
                    <option value="FSR">FSR - Faculty of Sports Science and Recreation</option>
                </select>
            </div>

            <div class="form-group">
                <label>System Role Mapping</label>
                <select name="role" id="edit-role">
                    <option value="USER">USER</option>
                    <option value="TEAM_MANAGER">TEAM_MANAGER</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
            </div>

            <button type="submit" class="btn btn--primary" style="margin-top:16px; width: 100%;">Save Modifications</button>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById("addUserModal").classList.add("is-open");
    }
    function closeAddModal() {
        document.getElementById("addUserModal").classList.remove("is-open");
    }
    function openEditModal(id, name, email, faculty, role) {
        document.getElementById("edit-userId").value = id;
        document.getElementById("edit-fullName").value = name;
        document.getElementById("edit-email").value = email;
        document.getElementById("edit-faculty").value = faculty; // Updates drop-down selection naturally
        document.getElementById("edit-role").value = role;
        document.getElementById("editUserModal").classList.add("is-open");
    }
    function closeEditModal() {
        document.getElementById("editUserModal").classList.remove("is-open");
    }
    
    // Global listener to close modal if backdrop window space area is clicked
    window.onclick = function(event) {
        var addModal = document.getElementById("addUserModal");
        var editModal = document.getElementById("editUserModal");
        if (event.target == addModal) {
            closeAddModal();
        }
        if (event.target == editModal) {
            closeEditModal();
        }
    }
</script>
</body>
</html>