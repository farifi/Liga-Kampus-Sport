package DAO;

import Model.Team;
import Model.Sport;
import Model.Competition;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeamDAO {

    public void insertTeam(Team team) {
        String sql = "INSERT INTO team (SPORT_ID, COMPETITION_ID, TEAM_NAME, COACH_NAME, FACULTY) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, team.getSport().getSportId());
                ps.setInt(2, team.getCompetition().getCompetitionId());
                ps.setString(3, team.getTeamName());
                ps.setString(4, team.getCoachName());
                ps.setString(5, team.getFaculty());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert team: " + e.getMessage(), e);
        }
    }

    public List<Team> selectAllTeams() {
        List<Team> teams = new ArrayList<>();
        String sql = "SELECT t.*, s.SPORT_NAME, c.COMPETITION_NAME " +
                     "FROM team t " +
                     "JOIN sports s ON t.SPORT_ID = s.SPORT_ID " +
                     "LEFT JOIN competition c ON t.COMPETITION_ID = c.COMPETITION_ID";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("No connection");
                return teams;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    teams.add(mapRow(rs));
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
        team.setCoachName(rs.getString("COACH_NAME"));
        team.setFaculty(rs.getString("FACULTY"));
        return team;
    }
}