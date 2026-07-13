package Controller;

import Model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/admin/admin.jsp",
    "/admin/team.jsp",
    "/admin/competition.jsp",
    "/manager/players.jsp",
    "/admin/team",
    "/admin/competition",
    "/admin/matches",
    "/admin/users",
    "/manager/players",
    "/matches.jsp",
    "/dashboard.jsp",
    "/league.jsp"
})
public class middlewareServlet implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        boolean developmentMode = true;

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        if (developmentMode) {
            chain.doFilter(request, response);
            return;
        }

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Public pages don't require login
        if (isPublicPage(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth.jsp?error=login_required");
            return;
        }

        if (isAdminOnlyPage(path) && !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/dashboard.jsp?error=unauthorized");
            return;
        }

        if (isManagerPage(path) && user.isGuest()) {
            res.sendRedirect(req.getContextPath() + "/auth.jsp?error=login_required");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPage(String path) {
        return path.equals("/dashboard.jsp")
            || path.equals("/matches.jsp")
            || path.equals("/league.jsp")
            || path.equals("/auth.jsp");
    }

    private boolean isAdminOnlyPage(String path) {
        return path.equals("/admin/admin.jsp")
            || path.equals("/admin/competition.jsp")
            || path.equals("/admin/team.jsp")
            || path.equals("/admin/competition")
            || path.equals("/admin/team")
            || path.equals("/admin/matches")
            || path.equals("/admin/users");
    }

    private boolean isManagerPage(String path) {
        return path.equals("/manager/players.jsp")
            || path.equals("/manager/players");
    }
}