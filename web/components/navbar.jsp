<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Mobile hamburger toggle -->
<button class="nav-toggle" id="navToggle" aria-label="Toggle navigation" aria-expanded="false">
    <span></span>
    <span></span>
    <span></span>
</button>

<!-- Overlay (mobile) -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="logo">LIGA-KAMPUS</div>
    <p class="sub">University Multi-Sport System · UiTM</p>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/matches.jsp">Matches</a></li>
            <li><a href="${pageContext.request.contextPath}/competitions.jsp">Competition Management</a></li>
            <li><a href="${pageContext.request.contextPath}/teams.jsp">Teams &amp; Coaches</a></li>
            <li><a href="${pageContext.request.contextPath}/players.jsp">Players</a></li>
            <li><a href="${pageContext.request.contextPath}/standings.jsp">League Standings</a></li>
            <li><a href="${pageContext.request.contextPath}/admin.jsp">Admin Panel</a></li>
        </ul>
    </nav>
</aside>

<!-- Mobile sidebar JS -->
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

        toggle.addEventListener('click', function () {
            sidebar.classList.contains('is-open') ? closeNav() : openNav();
        });

        overlay.addEventListener('click', closeNav);

        /* Highlight active link */
        const links = sidebar.querySelectorAll('a');
        links.forEach(function (link) {
            if (link.href === window.location.href) {
                link.classList.add('is-active');
            }
        });
    })();
</script>
