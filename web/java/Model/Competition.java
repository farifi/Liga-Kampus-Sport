package Model;

public class Competition {
    private int competitionId;
    private Sport sport;
    private String competitionName;
    private String format;
    private String status;

    public int getCompetitionId() { return competitionId; }
    public void setCompetitionId(int competitionId) { this.competitionId = competitionId; }

    public Sport getSport() { return sport; }
    public void setSport(Sport sport) { this.sport = sport; }

    public String getCompetitionName() { return competitionName; }
    public void setCompetitionName(String competitionName) { this.competitionName = competitionName; }

    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}