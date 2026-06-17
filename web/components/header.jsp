<%@ page contentType="text/html;charset=UTF-8" import="Model.User" %>
<%
    User user = (User) request.getAttribute("user");
    String username = (user != null) ? user.getFullName() : null;

    boolean loggedIn = username != null;
    String avatar = "GU";
    if (loggedIn && username.length() >= 2) {
        avatar = username.substring(0, 2).toUpperCase();
    } else if (loggedIn) {
        avatar = username.substring(0, 1).toUpperCase();
    }
%>

<!-- Page Header Component -->
<header class="page-header">

    <div class="page-header__left">
        <span class="page-header__title">LIGA-KAMPUS</span>

        <span class="page-header__subtitle">
            <%= loggedIn
                    ? "Welcome back — here's what's happening today"
                    : "Welcome to LIGA-KAMPUS. Please login to access management features." %>
        </span>
    </div>

    <div class="page-header__right">

        <% if (loggedIn) { %>

            <div class="user-pill">
                <div class="user-pill__avatar"><%= avatar %></div>
                <div>
                    <div class="user-pill__name"><%= username %></div>
                    <div class="user-pill__role"><%= user.getRole() %></div>
                </div>
            </div>

            <button
                type="button"
                class="btn--logout"
                onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
                Logout
            </button>

        <% } else { %>

            <button
                type="button"
                class="btn--secondary"
                onclick="window.location.href='${pageContext.request.contextPath}/auth.jsp'">
                Login
            </button>

            <button
                type="button"
                class="btn--primary"
                onclick="window.location.href='${pageContext.request.contextPath}/auth.jsp'">
                Sign Up
            </button>

        <% } %>

    </div>

</header>   