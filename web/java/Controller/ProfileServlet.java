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

@WebServlet(name = "profileServlet", urlPatterns = {"/manager/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("user") : null;
        String userRole = session != null ? (String) session.getAttribute("role") : null;
        System.out.println("DEBUG: userRole=" + userRole + " user=" + (currentUser != null ? currentUser.getFullName() : "null"));
        if (currentUser == null || (!"ADMIN".equalsIgnoreCase(userRole) && !"MANAGER".equalsIgnoreCase(userRole) && !"TEAM_MANAGER".equalsIgnoreCase(userRole))) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        request.getRequestDispatcher("/manager/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("user") : null;
        String userRole = session != null ? (String) session.getAttribute("role") : null;

        if (currentUser == null || (!"ADMIN".equalsIgnoreCase(userRole) && !"MANAGER".equalsIgnoreCase(userRole) && !"TEAM_MANAGER".equalsIgnoreCase(userRole))) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp?error=unauthorized");
            return;
        }

        String fullName = request.getParameter("fullName");
        String faculty = request.getParameter("faculty");
        String password = request.getParameter("password");

        if (fullName != null && !fullName.isBlank()) {
            UserDAO userDAO = new UserDAO();
            currentUser.setFullName(fullName);
            currentUser.setFaculty(faculty);

            boolean updatePassword = password != null && !password.isBlank();
            if (updatePassword) {
                currentUser.setPassword(password);
            }

            userDAO.updateUser(currentUser, updatePassword);
            session.setAttribute("user", currentUser);
            response.sendRedirect(request.getContextPath() + "/manager/profile?success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/profile?error=invalid");
        }
    }
}
