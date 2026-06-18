package Model;

public class MatchEvent {

    // Attributes
    private String eventId;     // PK
    private Match  match;       // FK - MATCH_ID
    private Player player;      // FK - PLAYER_ID
    private String eventType;   // e.g. "GOAL", "YELLOW_CARD", "RED_CARD"
    private int    minute;
    private String description;

    // Default Constructor
    public MatchEvent() {
    }

    // Parameterized Constructor
    public MatchEvent(String eventId, Match match, Player player,
                      String eventType, int minute, String description) {
        this.eventId     = eventId;
        this.match       = match;
        this.player      = player;
        this.eventType   = eventType;
        this.minute      = minute;
        this.description = description;
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

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public int getMinute() {
        return minute;
    }

    public void setMinute(int minute) {
        this.minute = minute;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
