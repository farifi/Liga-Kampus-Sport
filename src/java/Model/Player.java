package Model; 

public class Player {
    // Attributes
    private String playerId; 
    private Team team;       // Maps to FK1 TEAM_ID
    private Sports sport;    // Maps to FK1 SPORT_ID
    private String playerName;
    private String studentId;

    // Default Constructor
    public Player() {
    }

    // Parameterized Constructor
    public Player(String playerId, Team team, Sports sport, String playerName, String studentId) {
        this.playerId = playerId;
        this.team = team;
        this.sport = sport;
        this.playerName = playerName;
        this.studentId = studentId;
    }

    // Getters and Setters
    public String getPlayerId() {
        return playerId;
    }

    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
        this.team = team;
    }

    public Sports getSport() {
        return sport;
    }

    public void setSport(Sports sport) {
        this.sport = sport;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
}