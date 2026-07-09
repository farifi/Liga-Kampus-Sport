package DAO;

import Model.Competition;
import Model.Sport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompetitionDAO {

    public List<Competition> selectAllCompetitions() {
        List<Competition> competitions = new ArrayList<>();
        String sql = "SELECT c.*, s.SPORT_NAME, s.SPORT_TYPE " +
                     "FROM competition c JOIN sports s ON c.SPORT_ID = s.SPORT_ID " +
                     "ORDER BY c.COMPETITION_NAME";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return competitions; }

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    competitions.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve competitions: " + e.getMessage(), e);
        }

        return competitions;
    }

    public List<Competition> selectCompetitionsBySport(int sportId) {
        List<Competition> competitions = new ArrayList<>();
        String sql = "SELECT c.*, s.SPORT_NAME, s.SPORT_TYPE " +
                     "FROM competition c JOIN sports s ON c.SPORT_ID = s.SPORT_ID " +
                     "WHERE c.SPORT_ID = ? ORDER BY c.COMPETITION_NAME";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return competitions; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, sportId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        competitions.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve competitions: " + e.getMessage(), e);
        }

        return competitions;
    }

    public Competition selectCompetitionById(int competitionId) {
        String sql = "SELECT c.*, s.SPORT_NAME, s.SPORT_TYPE " +
                     "FROM competition c JOIN sports s ON c.SPORT_ID = s.SPORT_ID " +
                     "WHERE c.COMPETITION_ID = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) { System.out.println("No connection"); return null; }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, competitionId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve competition: " + e.getMessage(), e);
        }

        return null;
    }

    private Competition mapRow(ResultSet rs) throws SQLException {
        Sport sport = new Sport();
        sport.setSportId(rs.getInt("SPORT_ID"));
        sport.setSportName(rs.getString("SPORT_NAME"));
        sport.setSportType(rs.getString("SPORT_TYPE"));

        Competition competition = new Competition();
        competition.setCompetitionId(rs.getInt("COMPETITION_ID"));
        competition.setSport(sport);
        competition.setCompetitionName(rs.getString("COMPETITION_NAME"));
        competition.setFormat(rs.getString("FORMAT"));
        competition.setStatus(rs.getString("STATUS"));
        return competition;
    }

    public void insertCompetition(Competition competition) {
        String sql = "INSERT INTO competition (COMPETITION_NAME, FORMAT, SPORT_ID, STATUS) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, competition.getCompetitionName());
                ps.setString(2, competition.getFormat());
                ps.setInt(3, competition.getSport().getSportId());
                ps.setString(4, competition.getStatus());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert competition: " + e.getMessage(), e);
        }
    }

    public void updateCompetition(Competition competition) {
        String sql = "UPDATE competition SET COMPETITION_NAME = ?, FORMAT = ?, SPORT_ID = ?, STATUS = ? WHERE COMPETITION_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, competition.getCompetitionName());
                ps.setString(2, competition.getFormat());
                ps.setInt(3, competition.getSport().getSportId());
                ps.setString(4, competition.getStatus());
                ps.setInt(5, competition.getCompetitionId());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update competition: " + e.getMessage(), e);
        }
    }

    public void deleteCompetition(int competitionId) {
        String sql = "DELETE FROM competition WHERE COMPETITION_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, competitionId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete competition: " + e.getMessage(), e);
        }
    }
}