package Model; // Change this to match your actual NetBeans package name

public class Match {
    // Attributes
    private String matchId;         // or int, depending on your database type
    private Sports sport;           // Maps to FK1 SPORT_ID
    private Competition competition; // Maps to FK2 COMPETITION_ID
    private Team team1;             // Maps to FK3 TEAM_1_ID
    private Team team2;             // Maps to FK4 TEAM_2_ID
    private String venue;
    private String date;            // Can also use java.util.Date or java.time.LocalDate
    private int score1;
    private int score2;
    private String status;

    // Default Constructor
    public Match() {
    }

    // Parameterized Constructor
    public Match(String matchId, Sports sport, Competition competition, Team team1, Team team2, 
                 String venue, String date, int score1, int score2, String status) {
        this.matchId = matchId;
        this.sport = sport;
        this.competition = competition;
        this.team1 = team1;
        this.team2 = team2;
        this.venue = venue;
        this.date = date;
        this.score1 = score1;
        this.score2 = score2;
        this.status = status;
    }

    // Getters and Setters
    public String getMatchId() {
        return matchId;
    }

    public void setMatchId(String matchId) {
        this.matchId = matchId;
    }

    public Sports getSport() {
        return sport;
    }

    public void setSport(Sports sport) {
        this.sport = sport;
    }

    public Competition getCompetition() {
        return competition;
    }

    public void setCompetition(Competition competition) {
        this.competition = competition;
    }

    public Team getTeam1() {
        return team1;
    }

    public void setTeam1(Team team1) {
        this.team1 = team1;
    }

    public Team getTeam2() {
        return team2;
    }

    public void setTeam2(Team team2) {
        this.team2 = team2;
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getScore1() {
        return score1;
    }

    public void setScore1(int score1) {
        this.score1 = score1;
    }

    public int getScore2() {
        return score2;
    }

    public void setScore2(int score2) {
        this.score2 = score2;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}