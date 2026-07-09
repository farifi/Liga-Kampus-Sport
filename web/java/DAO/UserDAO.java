package DAO;

import Model.User;
import java.sql.*;

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

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("USER_ID"));
        user.setFullName(rs.getString("FULL_NAME"));
        user.setEmail(rs.getString("EMAIL"));
        user.setRole(rs.getString("ROLE"));
        user.setFaculty(rs.getString("FACULTY"));
        return user;
    }

    public void updateUser(User user, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE users SET FULL_NAME = ?, FACULTY = ?, PASSWORD = ? WHERE USER_ID = ?";
        } else {
            sql = "UPDATE users SET FULL_NAME = ?, FACULTY = ? WHERE USER_ID = ?";
        }
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getFaculty());
                if (updatePassword) {
                    ps.setString(3, user.getPassword());
                    ps.setInt(4, user.getUserId());
                } else {
                    ps.setInt(3, user.getUserId());
                }
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update user profile: " + e.getMessage(), e);
        }
    }
}