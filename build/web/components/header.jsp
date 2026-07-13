<%@ page contentType="text/html;charset=UTF-8" import="Model.User" %>
<%
    User user = (session != null) ? (User) session.getAttribute("user") : null;
    String username = (user != null) ? user.getFullName() : null;
    boolean loggedIn = username != null && !username.isBlank();

    String avatar = "GU";
    if (loggedIn) {
        String trimmed = username.trim();
        avatar = (trimmed.length() >= 2) ? trimmed.substring(0, 2).toUpperCase() : trimmed.substring(0, 1).toUpperCase();
    }
%>
<header class="page-header">
    <div class="page-header__left">
        <span class="page-header__title">LIGA-KAMPUS</span>
        <span class="page-header__subtitle">
            <%= loggedIn ? "Welcome back — here's what's happening today" : "Please login to access management features" %>
        </span>
    </div>

    <div class="page-header__right">
        <% if (loggedIn) { %>
            <a href="${pageContext.request.contextPath}/manager/profile" style="text-decoration:none; color:inherit; display:block;">
                <div class="user-pill" style="cursor:pointer;">
                    <div class="user-pill__avatar">
                        <% if (user.getProfileImage() != null && !user.getProfileImage().isBlank()) { %>
                            <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                        <% } else { %>
                            <%= avatar %>
                        <% } %>
                    </div>
                    <div>
                        <div class="user-pill__name"><%= username %></div>
                        <div class="user-pill__role"><%= user.getRole() != null ? user.getRole().toLowerCase() : "" %></div>
                    </div>
                </div>
            </a>
            <button type="button" class="btn--logout" onclick="window.location.href='${pageContext.request.contextPath}/logout'">Logout</button>
        <% } else { %>
            <button type="button" class="btn btn--ghost" onclick="window.location.href='${pageContext.request.contextPath}/auth.jsp'">Login</button>
            <button type="button" class="btn btn--primary" onclick="window.location.href='${pageContext.request.contextPath}/auth.jsp'">Sign Up</button>
        <% } %>
    </div>
</header>
