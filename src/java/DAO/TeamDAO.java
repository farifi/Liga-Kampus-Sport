package DAO;

import Model.Team;
import Model.Sport;
import Model.Competition;
import Model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamDAO {

    public void insertTeam(Team team) {
        String sql = "INSERT INTO team (SPORT_ID, COMPETITION_ID, TEAM_NAME, FACULTY, MANAGER_ID) VALUES (?, ?, ?, ?, ?)";
        String sqlStats = "INSERT INTO team_statistics (TEAM_ID, GAMES_PLAYED, WINS, DRAWS, LOSSES) VALUES (?, 0, 0, 0, 0)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, team.getSport().getSportId());
                ps.setInt(2, team.getCompetition().getCompetitionId());
                ps.setString(3, team.getTeamName());
                ps.setString(4, team.getFaculty());
                if (team.getManager() != null && team.getManager().getUserId() > 0) {
                    ps.setInt(5, team.getManager().getUserId());
                } else {
                    ps.setNull(5, Types.INTEGER);
                }
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int teamId = rs.getInt(1);
                        try (PreparedStatement psStats = conn.prepareStatement(sqlStats)) {
                            psStats.setInt(1, teamId);
                            psStats.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert team: " + e.getMessage(), e);
        }
    }

    public List<Team> selectAllTeams() {
        String sql = "SELECT t.*, s.SPORT_NAME, c.COMPETITION_NAME, u.FULL_NAME AS MANAGER_NAME " +
                     "FROM team t " +
                     "JOIN sports s ON t.SPORT_ID = s.SPORT_ID " +
                     "LEFT JOIN competition c ON t.COMPETITION_ID = c.COMPETITION_ID " +
                     "LEFT JOIN users u ON t.MANAGER_ID = u.USER_ID";
        return queryTeams(sql, null);
    }

    // Returns only the teams a given manager account is assigned to (used to enforce
    // that a team manager can only manage the roster of their own team).
    public List<Team> selectTeamsByManager(int managerId) {
        String sql = "SELECT t.*, s.SPORT_NAME, c.COMPETITION_NAME, u.FULL_NAME AS MANAGER_NAME " +
                     "FROM team t " +
                     "JOIN sports s ON t.SPORT_ID = s.SPORT_ID " +
                     "LEFT JOIN competition c ON t.COMPETITION_ID = c.COMPETITION_ID " +
                     "LEFT JOIN users u ON t.MANAGER_ID = u.USER_ID " +
                     "WHERE t.MANAGER_ID = ?";
        return queryTeams(sql, managerId);
    }

    public Team selectTeamById(int teamId) {
        String sql = "SELECT t.*, s.SPORT_NAME, c.COMPETITION_NAME, u.FULL_NAME AS MANAGER_NAME " +
                     "FROM team t " +
                     "JOIN sports s ON t.SPORT_ID = s.SPORT_ID " +
                     "LEFT JOIN competition c ON t.COMPETITION_ID = c.COMPETITION_ID " +
                     "LEFT JOIN users u ON t.MANAGER_ID = u.USER_ID " +
                     "WHERE t.TEAM_ID = ?";
        List<Team> results = queryTeams(sql, teamId);
        return results.isEmpty() ? null : results.get(0);
    }

    private List<Team> queryTeams(String sql, Integer filterId) {
        List<Team> teams = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("No connection");
                return teams;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (filterId != null) {
                    ps.setInt(1, filterId);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        teams.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve teams: " + e.getMessage(), e);
        }
        return teams;
    }

    private Team mapRow(ResultSet rs) throws SQLException {
        Sport sport = new Sport();
        sport.setSportId(rs.getInt("SPORT_ID"));
        sport.setSportName(rs.getString("SPORT_NAME"));

        Competition comp = new Competition();
        comp.setCompetitionId(rs.getInt("COMPETITION_ID"));
        comp.setCompetitionName(rs.getString("COMPETITION_NAME"));

        Team team = new Team();
        team.setTeamId(rs.getInt("TEAM_ID"));
        team.setSport(sport);
        team.setCompetition(comp);
        team.setTeamName(rs.getString("TEAM_NAME"));
        team.setFaculty(rs.getString("FACULTY"));

        int managerId = rs.getInt("MANAGER_ID");
        if (!rs.wasNull()) {
            User manager = new User();
            manager.setUserId(managerId);
            manager.setFullName(rs.getString("MANAGER_NAME"));
            team.setManager(manager);
        }
        return team;
    }

    public void updateTeam(Team team) {
        String sql = "UPDATE team SET SPORT_ID = ?, COMPETITION_ID = ?, TEAM_NAME = ?, FACULTY = ?, MANAGER_ID = ? WHERE TEAM_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, team.getSport().getSportId());
                ps.setInt(2, team.getCompetition().getCompetitionId());
                ps.setString(3, team.getTeamName());
                ps.setString(4, team.getFaculty());
                if (team.getManager() != null && team.getManager().getUserId() > 0) {
                    ps.setInt(5, team.getManager().getUserId());
                } else {
                    ps.setNull(5, Types.INTEGER);
                }
                ps.setInt(6, team.getTeamId());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update team: " + e.getMessage(), e);
        }
    }

    public void deleteTeam(int teamId) {
        String sql = "DELETE FROM team WHERE TEAM_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, teamId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete team: " + e.getMessage(), e);
        }
    }
}