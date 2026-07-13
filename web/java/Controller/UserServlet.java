package Controller;

import Model.User;
import DAO.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "userServlet", urlPatterns = {"/admin/users"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<User> listUser = userDAO.selectAllUsers();
        request.setAttribute("listUser", listUser);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String faculty = request.getParameter("faculty");
            String role = request.getParameter("role");

            if (fullName != null && !fullName.isBlank() && email != null && !email.isBlank()
                    && password != null && !password.isBlank()) {
                User user = new User();
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPassword(password);
                user.setFaculty(faculty);
                user.setRole(role != null ? role : "USER");
                userDAO.insertUser(user);
            }
        } else if ("update".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String faculty = request.getParameter("faculty");
            String role = request.getParameter("role");

            if (userIdParam != null && fullName != null && !fullName.isBlank()
                    && email != null && !email.isBlank()) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    User user = new User();
                    user.setUserId(userId);
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setFaculty(faculty);
                    user.setRole(role != null ? role : "USER");

                    boolean updatePassword = password != null && !password.isBlank();
                    if (updatePassword) {
                        user.setPassword(password);
                    }
                    userDAO.adminUpdateUser(user, updatePassword);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    // Prevent an admin from deleting their own account mid-session
                    User currentUser = getCurrentUser(request);
                    if (currentUser == null || currentUser.getUserId() != userId) {
                        userDAO.deleteUser(userId);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (User) session.getAttribute("user") : null;
    }

    private boolean isAdmin(HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        return currentUser != null && ("ADMIN".equalsIgnoreCase(role) || currentUser.isAdmin());
    }
}
