package Controller;

import Model.User;
import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "authServlet", urlPatterns = {"/authServlet"})
public class authServlet extends HttpServlet {

    // Fixed to uppercase to match your navbar logic checking for "TEAM_MANAGER"
    private static final String DEFAULT_SIGNUP_ROLE = "TEAM_MANAGER"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); 
        HttpSession session = request.getSession();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        if (action.equalsIgnoreCase("login")) {
            handleLogin(request, response, session);
        } else if (action.equalsIgnoreCase("signup")) {
            handleSignup(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        User userResult = dao.selectUserByEmailAndPassword(email, password);

        if (userResult == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=invalid_credentials");
            return;
        }

        session.setAttribute("user", userResult); 
        session.setAttribute("role", userResult.getRole() != null ? userResult.getRole().toUpperCase() : "GUEST");
        session.setAttribute("UserID", userResult.getUserId());

        if (userResult.isAdmin() || "ADMIN".equalsIgnoreCase(userResult.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String faculty  = request.getParameter("faculty");

        if (fullName == null || email == null || password == null || faculty == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        boolean isAlreadyRegistered = dao.selectUserByEmail(email) != null;

        if (isAlreadyRegistered) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=email_taken");
        } else {
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(password);
            user.setFaculty(faculty);
            user.setRole(DEFAULT_SIGNUP_ROLE);

            dao.insertUser(user);
            response.sendRedirect(request.getContextPath() + "/auth.jsp?success=registered");
        }
    }
}