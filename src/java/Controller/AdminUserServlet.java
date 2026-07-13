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
@WebServlet(name = "adminUsersServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        
        // Fetch all registered users for the administration workspace table grid
        List<User> listUser = userDAO.selectAllUsers();
        request.setAttribute("listUser", listUser);
        // CHANGED PATH: Forward directly to /admin/users.jsp because the folder is outside WEB-INF
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String faculty = request.getParameter("faculty");
            if (fullName != null && email != null && password != null) {
                User newUser = new User();
                newUser.setFullName(fullName);
                newUser.setEmail(email);
                newUser.setPassword(password);
                newUser.setRole(role);
                newUser.setFaculty(faculty);
                userDAO.insertUser(newUser);
            }
            
        } else if ("update".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String faculty = request.getParameter("faculty");
            String password = request.getParameter("password");
            if (userIdParam != null) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    User updatedUser = new User();
                    updatedUser.setUserId(userId);
                    updatedUser.setFullName(fullName);
                    updatedUser.setEmail(email);
                    updatedUser.setRole(role);
                    updatedUser.setFaculty(faculty);

                    boolean updatePassword = password != null && !password.isBlank();
                    if (updatePassword) {
                        updatedUser.setPassword(password);
                    }
                    userDAO.adminUpdateUser(updatedUser, updatePassword);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            
        } else if ("delete".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    userDAO.deleteUser(userId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        // Redirect back to the view endpoint to cleanly render updates
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}