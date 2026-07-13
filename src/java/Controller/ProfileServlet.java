package Controller;

import Model.User;
import DAO.UserDAO;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "profileServlet", urlPatterns = {"/manager/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("user") : null;
        String userRole = session != null ? (String) session.getAttribute("role") : null;
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
        
        String profileImage = request.getParameter("existingProfileImage");
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (fileName != null && !fileName.isEmpty()) {
                String uniqueName = System.currentTimeMillis() + "_" + fileName;
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                filePart.write(uploadPath + File.separator + uniqueName);
                profileImage = "uploads/" + uniqueName;
            }
        }

        if (fullName != null && !fullName.isBlank()) {
            UserDAO userDAO = new UserDAO();
            currentUser.setFullName(fullName);
            currentUser.setFaculty(faculty);
            currentUser.setProfileImage(profileImage);

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
