package DAO;

import Model.Team;
import Model.TeamStatistic;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamStatisticDAO {
    public List<TeamStatistic> selectStandingsByCompetition(int competitionId) {
        List<TeamStatistic> list = new ArrayList<>();
        String sql = "SELECT ts.*, t.TEAM_NAME, t.FACULTY, s.SPORT_NAME " +
                     "FROM team_statistics ts " +
                     "JOIN team t ON ts.TEAM_ID = t.TEAM_ID " +
                     "JOIN sports s ON t.SPORT_ID = s.SPORT_ID " +
                     "WHERE t.COMPETITION_ID = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("No database connection available.");
                return list;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, competitionId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Team team = new Team();
                        team.setTeamId(rs.getInt("TEAM_ID"));
                        team.setTeamName(rs.getString("TEAM_NAME"));
                        team.setFaculty(rs.getString("FACULTY"));

                        Model.Sport sport = new Model.Sport();
                        sport.setSportName(rs.getString("SPORT_NAME"));
                        team.setSport(sport);

                        TeamStatistic stat = new TeamStatistic();
                        stat.setTeamStatId(rs.getInt("TEAM_STAT_ID"));
                        stat.setTeam(team);
                        stat.setGamesPlayed(rs.getInt("GAMES_PLAYED"));
                        stat.setWins(rs.getInt("WINS"));
                        stat.setDraws(rs.getInt("DRAWS"));
                        stat.setLosses(rs.getInt("LOSSES"));

                        list.add(stat);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error loading league standings: " + e.getMessage(), e);
        }
        return list;
    }

    public void recalculateTeamStatistics(int teamId) {
        String sql = "SELECT " +
                     "  (SELECT COUNT(*) FROM matches WHERE (TEAM_1_ID = ? OR TEAM_2_ID = ?) AND STATUS = 'COMPLETED') AS games_played, " +
                     "  (SELECT COUNT(*) FROM matches WHERE ((TEAM_1_ID = ? AND SCORE_1 > SCORE_2) OR (TEAM_2_ID = ? AND SCORE_2 > SCORE_1)) AND STATUS = 'COMPLETED') AS wins, " +
                     "  (SELECT COUNT(*) FROM matches WHERE (TEAM_1_ID = ? OR TEAM_2_ID = ?) AND SCORE_1 = SCORE_2 AND STATUS = 'COMPLETED') AS draws, " +
                     "  (SELECT COUNT(*) FROM matches WHERE ((TEAM_1_ID = ? AND SCORE_1 < SCORE_2) OR (TEAM_2_ID = ? AND SCORE_2 < SCORE_1)) AND STATUS = 'COMPLETED') AS losses";
        String updateSql = "UPDATE team_statistics SET GAMES_PLAYED = ?, WINS = ?, DRAWS = ?, LOSSES = ? WHERE TEAM_ID = ?";
        String insertSql = "INSERT INTO team_statistics (TEAM_ID, GAMES_PLAYED, WINS, DRAWS, LOSSES) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            int gamesPlayed = 0;
            int wins = 0;
            int draws = 0;
            int losses = 0;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, teamId);
                ps.setInt(2, teamId);
                ps.setInt(3, teamId);
                ps.setInt(4, teamId);
                ps.setInt(5, teamId);
                ps.setInt(6, teamId);
                ps.setInt(7, teamId);
                ps.setInt(8, teamId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        gamesPlayed = rs.getInt("games_played");
                        wins = rs.getInt("wins");
                        draws = rs.getInt("draws");
                        losses = rs.getInt("losses");
                    }
                }
            }
            boolean exists = false;
            String checkSql = "SELECT 1 FROM team_statistics WHERE TEAM_ID = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, teamId);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    exists = rsCheck.next();
                }
            }
            if (exists) {
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setInt(1, gamesPlayed);
                    psUpdate.setInt(2, wins);
                    psUpdate.setInt(3, draws);
                    psUpdate.setInt(4, losses);
                    psUpdate.setInt(5, teamId);
                    psUpdate.executeUpdate();
                }
            } else {
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, teamId);
                    psInsert.setInt(2, gamesPlayed);
                    psInsert.setInt(3, wins);
                    psInsert.setInt(4, draws);
                    psInsert.setInt(5, losses);
                    psInsert.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to recalculate team statistics: " + e.getMessage(), e);
        }
    }
}