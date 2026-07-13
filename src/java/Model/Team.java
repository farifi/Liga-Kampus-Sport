package Model;

public class Team {
    private int teamId;
    private Sport sport;
    private Competition competition;
    private String teamName;
    private String faculty;
    private User manager;

    public int getTeamId() { return teamId; }
    public void setTeamId(int teamId) { this.teamId = teamId; }

    public Sport getSport() { return sport; }
    public void setSport(Sport sport) { this.sport = sport; }

    public Competition getCompetition() { return competition; }
    public void setCompetition(Competition competition) { this.competition = competition; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public String getFaculty() { return faculty; }
    public void setFaculty(String faculty) { this.faculty = faculty; }

    public User getManager() { return manager; }
    public void setManager(User manager) { this.manager = manager; }
}