<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
    System.out.println("DEBUG JSP: userRole=" + userRole + " user=" + (currentUser != null ? currentUser.getFullName() : "null"));
    if (currentUser == null || (!"ADMIN".equalsIgnoreCase(userRole) && !"MANAGER".equalsIgnoreCase(userRole) && !"TEAM_MANAGER".equalsIgnoreCase(userRole))) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/competitionCSS.css">
    <title>Profile Settings - LIGA-KAMPUS</title>
</head>
<body>

<%@ include file="/components/navbar.jsp" %>

<main class="main-content">
<%@ include file="/components/header.jsp" %>

<section id="profile" class="section" style="max-width: 600px; margin: 0 auto;">
    <h2>Profile Settings</h2>
    <p class="hint section-lead">View and update your personal account settings.</p>

    <% if ("true".equals(request.getParameter("success"))) { %>
        <div class="alert-box alert-success">Profile updated successfully!</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert-box alert-danger">Invalid input! Please fill out all required fields.</div>
    <% } %>

    <div class="card card--tinted">
        <h3>Edit Details</h3>
        <form action="${pageContext.request.contextPath}/manager/profile" method="POST">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" value="<%= currentUser.getEmail() %>" disabled style="background: rgba(10,22,40,0.04); cursor: not-allowed;">
            </div>

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= currentUser.getFullName() %>" required>
            </div>

            <div class="form-group">
                <label>Faculty</label>
                <input type="text" name="faculty" value="<%= currentUser.getFaculty() != null ? currentUser.getFaculty() : "" %>">
            </div>

            <div class="form-group">
                <label>Role</label>
                <input type="text" value="<%= currentUser.getRole() %>" disabled style="background: rgba(10,22,40,0.04); cursor: not-allowed; text-transform: uppercase;">
            </div>

            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="password" placeholder="Leave blank to keep current password">
            </div>

            <button type="submit" class="btn btn--primary" style="margin-top:16px;">Save Changes</button>
        </form>
    </div>
</section>
</main>
</body>
</html>
