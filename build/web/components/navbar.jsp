<%@ page contentType="text/html;charset=UTF-8" %>

<%
//    String role = (String) session.getAttribute("role");

    String role = null;

    if (role == null) {
        role = "GUEST";
    }
%>

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

            <% if ("ADMIN".equals(role)) { %>
            
                <li>
                    <a href="${pageContext.request.contextPath}/admin/admin.jsp">
                        Admin Panel
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard.jsp">
                        Dashboard
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/admin/competitions.jsp">
                        Competition Management
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/admin/teams.jsp">
                        Teams & Coaches
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/matches.jsp">
                        Matches
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/league.jsp">
                        League Standings
                    </a>
                </li>

            <% } else if ("TEAM_MANAGER".equals(role)) { %>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard.jsp">
                        Dashboard
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/players.jsp">
                        Player Management
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/matches.jsp">
                        Matches
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/league.jsp">
                        League Standings
                    </a>
                </li>

            <% } else { %>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard.jsp">
                        Dashboard
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/matches.jsp">
                        Matches
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/league.jsp">
                        League Standings
                    </a>
                </li>
            <% } %>
        </ul>
    </nav>
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
