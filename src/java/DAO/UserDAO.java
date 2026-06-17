package DAO;

import Model.User;
import java.sql.*;

public class UserDAO {
    private final String JDBC_URL = "jdbc:mysql://localhost:3306/liga_kampus_db";
    private final String JDBC_USER = "root";
    private final String JDBC_PASS = "";

    public Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Message: " + e.getMessage());
        }
        return null;
    }

    public void insertUser(User user) {
        String sql = "INSERT INTO `user` (FULL_NAME, EMAIL, PASSWORD, ROLE, FACULTY) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
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
        String sql = "SELECT * FROM `user` WHERE EMAIL = ?";

        try (Connection conn = getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("USER_ID"));
                        user.setFullName(rs.getString("FULL_NAME"));
                        user.setEmail(rs.getString("EMAIL"));
                        user.setRole(rs.getString("ROLE"));
                        user.setFaculty(rs.getString("FACULTY"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve user: " + e.getMessage(), e);
        }

        return null;
    }

    public User selectUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM `user` WHERE EMAIL = ? AND PASSWORD = ?";

        try (Connection conn = getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        User user = new User();
                        user.setUserId(rs.getInt("USER_ID"));
                        user.setFullName(rs.getString("FULL_NAME"));
                        user.setEmail(rs.getString("EMAIL"));
                        user.setRole(rs.getString("ROLE"));
                        user.setFaculty(rs.getString("FACULTY"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve user: " + e.getMessage(), e);
        }

        return null;
    }
}