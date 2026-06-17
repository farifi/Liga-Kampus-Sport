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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if (action == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        if (action.equalsIgnoreCase("login")) {
            handleLogin(request, response, session);
        } else if (action.equalsIgnoreCase("signup")) {
            handleSignup(request, response);
        } else {
            response.sendRedirect("auth.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        User userResult = dao.selectUserByEmailAndPassword(email, password); // ✅ updated

        if (userResult == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        session.setAttribute("UserID", userResult.getUserId());
        request.setAttribute("user", userResult);

        if (userResult.isAdmin()) {
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } else if (userResult.isManager()) {
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("auth.jsp");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String faculty  = request.getParameter("faculty");

        if (fullName == null || email == null || password == null || faculty == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        boolean isAlreadyRegistered = dao.selectUserByEmail(email) != null; // ✅ updated

        if (isAlreadyRegistered) {
            response.sendRedirect("auth.jsp");
        } else {
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(password);
            user.setFaculty(faculty);

            dao.insertUser(user);
            System.out.println("User registered successfully!");
            response.sendRedirect("auth.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Auth Servlet — handles login and signup";
    }
}