package Controller;

import Model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.io.PrintWriter;

@WebFilter(urlPatterns = {
    "/admin.jsp",
    "/teams.jsp",
    "/players.jsp",
    "/competitions.jsp",
    "/matches.jsp",
    "/dashboard.jsp"
})
public class middlewareServlet implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        
        boolean developmentMode = true;
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        if (developmentMode) {
            chain.doFilter(request, response);
            return;

            
        } else {
            String path = req.getServletPath();
            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

            // Public
            if (isPublicPage(path)){
                chain.doFilter(request, response);
                return;
            }

            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/auth.jsp?error=login_required");
                return;
            }

            if (isAdminOnlyPage(path) && !user.isAdmin()) {
                res.sendRedirect(req.getContextPath() + "/dashboard.jsp?error=unauthorized");
            }

            if (isManagerPage(path) && user.isGuest()) {
                res.sendRedirect(req.getContextPath() + "/auth.jsp?error=login_required");
                return;
            }

            chain.doFilter(request, response);
        }
        
    }
    
    private boolean isPublicPage(String path) {
        return path.equals("/dashboard.jsp")
            || path.equals("/matches.jsp")
            || path.equals("/auth.jsp");
    }
    
    private boolean isAdminOnlyPage(String path) {
        return path.equals("/admin.jsp")
            || path.equals("/competitions.jsp");
    }

    private boolean isManagerPage(String path) {
        return path.equals("/teams.jsp")
            || path.equals("/players.jsp");
    }

}