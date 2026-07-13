package DAO;

import Model.Match;
import Model.Sport;
import Model.Competition;
import Model.Team;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MatchDAO {

    private static final String BASE_SELECT =
        "SELECT m.*, " +
        "       s.SPORT_NAME, s.SPORT_TYPE, " +
        "       c.COMPETITION_NAME, c.FORMAT, c.STATUS AS COMPETITION_STATUS, " +
        "       t1.TEAM_NAME AS TEAM1_NAME, t1.FACULTY AS TEAM1_FACULTY, " +
        "       t2.TEAM_NAME AS TEAM2_NAME, t2.FACULTY AS TEAM2_FACULTY " +
        "FROM matches m " +
        "JOIN sports s ON m.SPORT_ID = s.SPORT_ID " +
        "JOIN competition c ON m.COMPETITION_ID = c.COMPETITION_ID " +
        "JOIN team t1 ON m.TEAM_1_ID = t1.TEAM_ID " +
        "JOIN team t2 ON m.TEAM_2_ID = t2.TEAM_ID ";

    public List<Match> selectAllMatches() {
        return queryMatches(BASE_SELECT + "ORDER BY m.DATE", null);
    }

    public List<Match> selectMatchesBySport(int sportId) {
        return queryMatches(BASE_SELECT + "WHERE m.SPORT_ID = ? ORDER BY m.DATE", sportId);
    }

    public List<Match> selectMatchesByCompetition(int competitionId) {
        String sql = BASE_SELECT + "WHERE m.COMPETITION_ID = ? ORDER BY m.DATE";
        List<Match> matches = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return matches;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, competitionId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        matches.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve matches by competition: " + e.getMessage(), e);
        }
        return matches;
    }

    public Match selectMatchById(int matchId) {
        String sql = BASE_SELECT + "WHERE m.MATCH_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, matchId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve match by id: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * Updates scores and status for a specific match entry.
     */
    public void updateMatchResult(int matchId, int score1, int score2, String status) {
        String sql = "UPDATE matches SET SCORE_1 = ?, SCORE_2 = ?, STATUS = ? WHERE MATCH_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, score1);
                ps.setInt(2, score2);
                ps.setString(3, status);
                ps.setInt(4, matchId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update match score: " + e.getMessage(), e);
        }
    }

    private List<Match> queryMatches(String sql, Integer filterId) {
        List<Match> matches = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return matches;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (filterId != null) {
                    ps.setInt(1, filterId);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        matches.add(mapRow(rs));
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to retrieve matches: " + e.getMessage(), e);
        }
        return matches;
    }

    private Match mapRow(ResultSet rs) throws SQLException {
        Sport sport = new Sport();
        sport.setSportId(rs.getInt("SPORT_ID"));
        sport.setSportName(rs.getString("SPORT_NAME"));
        sport.setSportType(rs.getString("SPORT_TYPE"));

        Competition competition = new Competition();
        competition.setCompetitionId(rs.getInt("COMPETITION_ID"));
        competition.setCompetitionName(rs.getString("COMPETITION_NAME"));
        competition.setFormat(rs.getString("FORMAT"));
        competition.setStatus(rs.getString("COMPETITION_STATUS"));

        Team team1 = new Team();
        team1.setTeamId(rs.getInt("TEAM_1_ID"));
        team1.setTeamName(rs.getString("TEAM1_NAME"));
        team1.setFaculty(rs.getString("TEAM1_FACULTY"));

        Team team2 = new Team();
        team2.setTeamId(rs.getInt("TEAM_2_ID"));
        team2.setTeamName(rs.getString("TEAM2_NAME"));
        team2.setFaculty(rs.getString("TEAM2_FACULTY"));

        Match match = new Match();
        match.setMatchId(rs.getInt("MATCH_ID"));
        match.setSport(sport);
        match.setCompetition(competition);
        match.setTeam1(team1);
        match.setTeam2(team2);
        match.setVenue(rs.getString("VENUE"));
        match.setDate(rs.getString("DATE"));
        match.setScore1(rs.getInt("SCORE_1"));
        match.setScore2(rs.getInt("SCORE_2")); // Fixed: Fetching the missing SCORE_2 column values
        match.setStatus(rs.getString("STATUS"));
        return match;
    }

    public void insertMatch(Match match) {
        String sql = "INSERT INTO matches (SPORT_ID, COMPETITION_ID, TEAM_1_ID, TEAM_2_ID, VENUE, DATE, SCORE_1, SCORE_2, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, match.getSport().getSportId());
                ps.setInt(2, match.getCompetition().getCompetitionId());
                ps.setInt(3, match.getTeam1().getTeamId());
                ps.setInt(4, match.getTeam2().getTeamId());
                ps.setString(5, match.getVenue());
                ps.setString(6, match.getDate());
                ps.setInt(7, match.getScore1());
                ps.setInt(8, match.getScore2());
                ps.setString(9, match.getStatus());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to insert match: " + e.getMessage(), e);
        }
    }

    public void updateMatch(Match match) {
        String sql = "UPDATE matches SET SPORT_ID = ?, COMPETITION_ID = ?, TEAM_1_ID = ?, TEAM_2_ID = ?, VENUE = ?, DATE = ?, SCORE_1 = ?, SCORE_2 = ?, STATUS = ? WHERE MATCH_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, match.getSport().getSportId());
                ps.setInt(2, match.getCompetition().getCompetitionId());
                ps.setInt(3, match.getTeam1().getTeamId());
                ps.setInt(4, match.getTeam2().getTeamId());
                ps.setString(5, match.getVenue());
                ps.setString(6, match.getDate());
                ps.setInt(7, match.getScore1());
                ps.setInt(8, match.getScore2());
                ps.setString(9, match.getStatus());
                ps.setInt(10, match.getMatchId());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update match: " + e.getMessage(), e);
        }
    }

    public void deleteMatch(int matchId) {
        String sql = "DELETE FROM matches WHERE MATCH_ID = ?";
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, matchId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete match: " + e.getMessage(), e);
        }
    }
}