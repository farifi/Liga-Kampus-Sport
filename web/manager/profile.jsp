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
        <form action="${pageContext.request.contextPath}/manager/profile" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="existingProfileImage" value="<%= currentUser.getProfileImage() != null ? currentUser.getProfileImage() : "" %>">
            
            <div class="form-group" style="display: flex; flex-direction: column; align-items: center; margin-bottom: 20px;">
                <div style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; background: #e2e8f0; border: 2px solid rgba(0,0,0,0.1); margin-bottom: 10px; display: flex; align-items: center; justify-content: center;">
                    <% if (currentUser.getProfileImage() != null && !currentUser.getProfileImage().isBlank()) { %>
                        <img src="${pageContext.request.contextPath}/<%= currentUser.getProfileImage() %>" style="width: 100%; height: 100%; object-fit: cover;">
                    <% } else { %>
                        <span style="font-size: 36px; color: #718096; font-weight: bold;"><%= currentUser.getFullName().length() >= 2 ? currentUser.getFullName().substring(0, 2).toUpperCase() : "U" %></span>
                    <% } %>
                </div>
                <label style="cursor: pointer; padding: 6px 12px; background: #edf2f7; border-radius: 6px; font-size: 14px; font-weight: 500; color: #4a5568;">
                    Choose Photo
                    <input type="file" name="profileImage" accept="image/*" style="display: none;" onchange="this.nextElementSibling.innerText = this.files[0].name">
                    <span style="display: block; font-size: 11px; color: #a0aec0; margin-top: 4px; font-weight: normal;">No file selected</span>
                </label>
            </div>

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
