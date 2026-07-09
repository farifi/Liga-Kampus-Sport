<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { role = "GUEST"; }
%>
<button class="nav-toggle" id="navToggle" aria-label="Toggle navigation" aria-expanded="false">
    <span></span><span></span><span></span>
</button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<aside class="sidebar" id="sidebar">
    <div class="logo"><span class="logo-mark">LK</span> Liga-Kampus</div>
    <p class="sub">Inter-Faculty Sport System</p>

    <nav>
        <ul>
            <li class="nav-section-label">General</li>
            <li><a href="${pageContext.request.contextPath}/dashboard"><span class="nav-icon">&#127968;</span> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/matches"><span class="nav-icon">&#9917;</span> Matches</a></li>
            <li><a href="${pageContext.request.contextPath}/league"><span class="nav-icon">&#128202;</span> League Standings</a></li>

            <% if ("ADMIN".equals(role)) { %>
                <li class="nav-section-label">Administration</li>
                <li><a href="${pageContext.request.contextPath}/admin/admin.jsp"><span class="nav-icon">&#128100;</span> Admin Panel</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/competition"><span class="nav-icon">&#127942;</span> Competitions</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/team"><span class="nav-icon">&#128101;</span> Teams &amp; Coaches</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/matches"><span class="nav-icon">&#9917;</span> Manage Matches</a></li>

            <% } else if ("TEAM_MANAGER".equalsIgnoreCase(role) || "MANAGER".equalsIgnoreCase(role)) { %>
                <li class="nav-section-label">Team Management</li>
                <li><a href="${pageContext.request.contextPath}/manager/players"><span class="nav-icon">&#127955;</span> Player Management</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="sidebar-footer">LIGA-KAMPUS &middot; Inter-Faculty Tournament Manager</div>
</aside>

<script>
    (function () {
        const toggle  = document.getElementById('navToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        function openNav() {
            sidebar.classList.add('is-open');
            overlay.classList.add('is-visible');
            toggle.classList.add('is-open');
            toggle.setAttribute('aria-expanded', 'true');
            document.body.style.overflow = 'hidden';
        }
        function closeNav() {
            sidebar.classList.remove('is-open');
            overlay.classList.remove('is-visible');
            toggle.classList.remove('is-open');
            toggle.setAttribute('aria-expanded', 'false');
            document.body.style.overflow = '';
        }
        toggle.addEventListener('click', () => sidebar.classList.contains('is-open') ? closeNav() : openNav());
        overlay.addEventListener('click', closeNav);

        const links = sidebar.querySelectorAll('a');
        const currentUrl = window.location.href.split('?')[0];
        links.forEach(link => {
            if (link.href.split('?')[0] === currentUrl) link.classList.add('is-active');
        });
    })();
</script>
