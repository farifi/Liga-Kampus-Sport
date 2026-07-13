package DAO;

import Model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public void insertUser(User user) {
        String sql = "INSERT INTO `users` (FULL_NAME, EMAIL, PASSWORD, ROLE, FACULTY) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getPassword());
                ps.setString(4, user.getRole());
                ps.setString(5, user.getFaculty());
                ps.executeUpdate();
                System.out.println("User account successfully created!");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert user: " + e.getMessage(), e);
        }
    }

    public User selectUserByEmail(String email) {
        String sql = "SELECT * FROM `users` WHERE EMAIL = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve user: " + e.getMessage(), e);
        }
        return null;
    }

    public User selectUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM `users` WHERE EMAIL = ? AND PASSWORD = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve user: " + e.getMessage(), e);
        }
        return null;
    }

    /* =========================================================================
       ADMIN ACTIONS: READ ALL USERS (For Admin Table view)
       ========================================================================= */
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM `users` ORDER BY FULL_NAME ASC";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return users;
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve all users: " + e.getMessage(), e);
        }
        return users;
    }

    // Used to populate the "Team Manager" dropdown when assigning a manager to a team
    public List<User> selectManagers() {
    List<User> managers = new ArrayList<>();
    String sql = "SELECT * FROM `users` WHERE UPPER(ROLE) = 'MANAGER' ORDER BY FULL_NAME ASC";

    try (Connection conn = DBConnection.getConnection()) {
        if (conn == null) return managers;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                managers.add(mapRow(rs));
            }
        }
    } catch (SQLException e) {
        throw new RuntimeException("Failed to retrieve managers: " + e.getMessage(), e);
    }
    return managers;
}

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("USER_ID"));
        user.setFullName(rs.getString("FULL_NAME"));
        user.setEmail(rs.getString("EMAIL"));
        user.setRole(rs.getString("ROLE"));
        user.setFaculty(rs.getString("FACULTY"));
        user.setProfileImage(rs.getString("PROFILE_IMAGE")); // Safely map profile images across all queries
        return user;
    }

    /* =========================================================================
       USER SELF-SERVICE: PROFILE EDIT ENTRIES
       ========================================================================= */
    public void updateUser(User user, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE users SET FULL_NAME = ?, FACULTY = ?, PROFILE_IMAGE = ?, PASSWORD = ? WHERE USER_ID = ?";
        } else {
            sql = "UPDATE users SET FULL_NAME = ?, FACULTY = ?, PROFILE_IMAGE = ? WHERE USER_ID = ?";
        }
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getFaculty());
                ps.setString(3, user.getProfileImage());
                if (updatePassword) {
                    ps.setString(4, user.getPassword());
                    ps.setInt(5, user.getUserId());
                } else {
                    ps.setInt(4, user.getUserId());
                }
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update user profile: " + e.getMessage(), e);
        }
    }

    /* =========================================================================
       ADMIN ACTIONS: MODERATION & ACCOUNT REMOVALS
       ========================================================================= */
    public void adminUpdateUser(User user, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE users SET FULL_NAME = ?, EMAIL = ?, ROLE = ?, FACULTY = ?, PASSWORD = ? WHERE USER_ID = ?";
        } else {
            sql = "UPDATE users SET FULL_NAME = ?, EMAIL = ?, ROLE = ?, FACULTY = ? WHERE USER_ID = ?";
        }
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getRole());
                ps.setString(4, user.getFaculty());
                if (updatePassword) {
                    ps.setString(5, user.getPassword());
                    ps.setInt(6, user.getUserId());
                } else {
                    ps.setInt(5, user.getUserId());
                }
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to admin update user: " + e.getMessage(), e);
        }
    }

    public void deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE USER_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete user: " + e.getMessage(), e);
        }
    }
}