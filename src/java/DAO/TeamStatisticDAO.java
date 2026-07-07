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
}