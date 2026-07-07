package Model;

public class MatchEvent {
    private int eventId;
    private Match match;        // FK1 MATCH_ID
    private Player player;      // FK2 PLAYER_ID
    private Team team;          // FK3 TEAM_ID
    private String eventType;   // e.g. "GOAL", "YELLOW_CARD", "RED_CARD"
    private int eventMinute;
    private String time;

    public MatchEvent() {
    }

    public MatchEvent(int eventId, Match match, Player player, Team team,
                       String eventType, int eventMinute, String time) {
        this.eventId = eventId;
        this.match = match;
        this.player = player;
        this.team = team;
        this.eventType = eventType;
        this.eventMinute = eventMinute;
        this.time = time;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public Match getMatch() {
        return match;
    }

    public void setMatch(Match match) {
        this.match = match;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
        this.team = team;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public int getEventMinute() {
        return eventMinute;
    }

    public void setEventMinute(int eventMinute) {
        this.eventMinute = eventMinute;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}