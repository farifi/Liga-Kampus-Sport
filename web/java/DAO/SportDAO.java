package DAO;

import Model.Sport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SportDAO {

    public List<Sport> selectAllSports() {
        List<Sport> sports = new ArrayList<>();
        String sql = "SELECT * FROM sports ORDER BY SPORT_NAME";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return sports; }

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sports.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve sports: " + e.getMessage(), e);
        }

        return sports;
    }

    public Sport selectSportById(int sportId) {
        String sql = "SELECT * FROM sports WHERE SPORT_ID = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, sportId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve sport: " + e.getMessage(), e);
        }

        return null;
    }

    private Sport mapRow(ResultSet rs) throws SQLException {
        Sport sport = new Sport();
        sport.setSportId(rs.getInt("SPORT_ID"));
        sport.setSportName(rs.getString("SPORT_NAME"));
        sport.setSportType(rs.getString("SPORT_TYPE"));
        return sport;
    }
}