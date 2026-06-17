package Model;

public class Sport {
    // Attributes
    private String sportId;
    private String sportName;
    private String sportType;

    // Default Constructor
    public Sport() {
    }

    // Parameterized Constructor
    public Sport(String sportId, String sportName, String sportType) {
        this.sportId = sportId;
        this.sportName = sportName;
        this.sportType = sportType;
    }

    // Getters and Setters
    public String getSportId() {
        return sportId;
    }

    public void setSportId(String sportId) {
        this.sportId = sportId;
    }

    public String getSportName() {
        return sportName;
    }

    public void setSportName(String sportName) {
        this.sportName = sportName;
    }

    public String getSportType() {
        return sportType;
    }

    public void setSportType(String sportType) {
        this.sportType = sportType;
    }
}