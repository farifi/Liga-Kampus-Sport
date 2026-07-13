package Model;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String faculty;
    private String role;
    private String profileImage;

    public User() {
        this.userId   = -1;
        this.fullName = "";
        this.email    = "";
        this.password = "";
        this.faculty  = "";
        this.role     = "";
        this.profileImage = "";
    }

    public User(int userId, String fullName, String email, String password, String faculty, String role, String profileImage) {
        this.userId   = userId;
        this.fullName = fullName;
        this.email    = email;
        this.password = password;
        this.faculty  = faculty;
        this.role     = role;
        this.profileImage = profileImage;
    }

    public int    getUserId()   { return userId; }
    public String getFullName() { return fullName; }
    public String getEmail()    { return email; }
    public String getPassword() { return password; }
    public String getFaculty()  { return faculty; }
    public String getRole()     { return role; }
    public String getProfileImage() { return profileImage; }

    public void setUserId(int userId)  { this.userId = userId; }
    public void setFullName(String n)  { this.fullName = n; }
    public void setEmail(String e)     { this.email = e; }
    public void setPassword(String p)  { this.password = p; }
    public void setFaculty(String f)   { this.faculty = f; }
    public void setRole(String r)      { this.role = r; }
    public void setProfileImage(String img) { this.profileImage = img; }

    public boolean isAdmin()   { return "admin".equalsIgnoreCase(role); }
    public boolean isManager() { return "manager".equalsIgnoreCase(role); }
    public boolean isGuest()   { return "guest".equalsIgnoreCase(role); }
}