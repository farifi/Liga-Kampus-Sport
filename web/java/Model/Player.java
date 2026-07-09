package Model;

public class Player {
    private int playerId;
    private Team team;       // Maps to FK1 TEAM_ID
    private Sport sport;     // Maps to FK2 SPORT_ID
    private String playerName;
    private String studentId;
    private int jerseyNo;
    private String position;

    public Player() {
    }

    public Player(int playerId, Team team, Sport sport, String playerName, String studentId,
                  int jerseyNo, String position) {
        this.playerId = playerId;
        this.team = team;
        this.sport = sport;
        this.playerName = playerName;
        this.studentId = studentId;
        this.jerseyNo = jerseyNo;
        this.position = position;
    }

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
        this.team = team;
    }

    public Sport getSport() {
        return sport;
    }

    public void setSport(Sport sport) {
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

    public int getJerseyNo() {
        return jerseyNo;
    }

    public void setJerseyNo(int jerseyNo) {
        this.jerseyNo = jerseyNo;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}