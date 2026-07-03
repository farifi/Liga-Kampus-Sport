package Model;

public class TeamStatistic {
    // Attributes
    private String teamStatId;
    private Team team;      // FK TEAM_ID
    private int gamesPlayed;
    private int wins;
    private int draws;
    private int losses;

    // Default Constructor
    public TeamStatistic() {
    }

    // Parameterized Constructor
    public TeamStatistic(String teamStatId, Team team,
                         int gamesPlayed, int wins,
                         int draws, int losses) {
        this.teamStatId = teamStatId;
        this.team = team;
        this.gamesPlayed = gamesPlayed;
        this.wins = wins;
        this.draws = draws;
        this.losses = losses;
    }

    // Getters and Setters
    public String getTeamStatId() {
        return teamStatId;
    }

    public void setTeamStatId(String teamStatId) {
        this.teamStatId = teamStatId;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
        this.team = team;
    }

    public int getGamesPlayed() {
        return gamesPlayed;
    }

    public void setGamesPlayed(int gamesPlayed) {
        this.gamesPlayed = gamesPlayed;
    }

    public int getWins() {
        return wins;
    }

    public void setWins(int wins) {
        this.wins = wins;
    }

    public int getDraws() {
        return draws;
    }

    public void setDraws(int draws) {
        this.draws = draws;
    }

    public int getLosses() {
        return losses;
    }

    public void setLosses(int losses) {
        this.losses = losses;
    }
}