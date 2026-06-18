package Model;

public class MatchEvent {

    // Attributes
    private String eventId;     // PK
    private Match  match;       // FK1 - MATCH_ID
    private Player player;      // FK2 - PLAYER_ID
    private Team   team;        // FK3 - TEAM_ID
    private String eventType;   // e.g. "GOAL", "YELLOW_CARD", "RED_CARD"
    private int    eventMinute; // EVENT_MINUTE
    private String time;        // TIME

    // Default Constructor
    public MatchEvent() {
    }

    // Parameterized Constructor
    public MatchEvent(String eventId, Match match, Player player, Team team,
                      String eventType, int eventMinute, String time) {
        this.eventId     = eventId;
        this.match       = match;
        this.player      = player;
        this.team        = team;
        this.eventType   = eventType;
        this.eventMinute = eventMinute;
        this.time        = time;
    }

    // Getters and Setters
    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
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
