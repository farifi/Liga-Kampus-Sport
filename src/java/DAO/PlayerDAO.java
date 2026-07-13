package DAO;

import Model.Player;
import Model.Team;
import Model.Sport;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlayerDAO {

    public List<Player> selectPlayersByTeam(int teamId) {
        List<Player> players = new ArrayList<>();
        String sql = "SELECT p.*, t.TEAM_NAME, s.SPORT_NAME " +
                     "FROM players p " +
                     "JOIN team t ON p.TEAM_ID = t.TEAM_ID " +
                     "JOIN sports s ON p.SPORT_ID = s.SPORT_ID " +
                     "WHERE p.TEAM_ID = ? ORDER BY p.PLAYER_NAME";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return players;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, teamId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Player player = new Player();
                        player.setPlayerId(rs.getInt("PLAYER_ID"));
                        player.setPlayerName(rs.getString("PLAYER_NAME"));
                        player.setStudentId(rs.getString("STUDENT_ID"));
                        player.setJerseyNo(rs.getInt("JERSEY_NO"));
                        player.setPosition(rs.getString("POSITION"));
                        player.setPlayerImage(rs.getString("PLAYER_IMAGE"));

                        // Minimize hydration overhead by basic team tag mapping
                        Team team = new Team();
                        team.setTeamId(rs.getInt("TEAM_ID"));
                        team.setTeamName(rs.getString("TEAM_NAME"));
                        player.setTeam(team);

                        players.add(player);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch team roster: " + e.getMessage(), e);
        }
        return players;
    }
    
    public int countAllPlayers() {
        String sql = "SELECT COUNT(*) FROM players";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return 0;
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to count players: " + e.getMessage(), e);
        }
        return 0;
    }

    public void insertPlayer(Player player) {
        String sql = "INSERT INTO players (TEAM_ID, SPORT_ID, PLAYER_NAME, STUDENT_ID, JERSEY_NO, POSITION, PLAYER_IMAGE) " +
                     "VALUES (?, (SELECT SPORT_ID FROM team WHERE TEAM_ID = ?), ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, player.getTeam().getTeamId());
                ps.setInt(2, player.getTeam().getTeamId());
                ps.setString(3, player.getPlayerName());
                ps.setString(4, player.getStudentId());
                ps.setInt(5, player.getJerseyNo());
                ps.setString(6, player.getPosition());
                ps.setString(7, player.getPlayerImage());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert player: " + e.getMessage(), e);
        }
    }

    public void updatePlayer(Player player) {
        String sql = "UPDATE players SET PLAYER_NAME = ?, STUDENT_ID = ?, JERSEY_NO = ?, POSITION = ?, PLAYER_IMAGE = ? WHERE PLAYER_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, player.getPlayerName());
                ps.setString(2, player.getStudentId());
                ps.setInt(3, player.getJerseyNo());
                ps.setString(4, player.getPosition());
                ps.setString(5, player.getPlayerImage());
                ps.setInt(6, player.getPlayerId());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update player: " + e.getMessage(), e);
        }
    }

    public void deletePlayer(int playerId) {
        String sql = "DELETE FROM players WHERE PLAYER_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, playerId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete player: " + e.getMessage(), e);
        }
    }

    // Looks up which team a player currently belongs to, straight from the DB.
    // Used to verify ownership before a manager is allowed to update/delete a player,
    // instead of trusting a client-supplied teamId that could be tampered with.
    public int selectTeamIdForPlayer(int playerId) {
        String sql = "SELECT TEAM_ID FROM players WHERE PLAYER_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return -1;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, playerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("TEAM_ID");
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to look up player's team: " + e.getMessage(), e);
        }
        return -1;
    }

    public String selectPlayerImage(int playerId) {
        String sql = "SELECT PLAYER_IMAGE FROM players WHERE PLAYER_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, playerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString("PLAYER_IMAGE");
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to look up player image: " + e.getMessage(), e);
        }
        return null;
    }
}