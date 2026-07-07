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
}