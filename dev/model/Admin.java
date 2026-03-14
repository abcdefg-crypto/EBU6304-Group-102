package dev.model;


//管理员类

public class Admin extends User {
    public Admin() { this.role = Role.ADMIN; }
    public Admin(String id, String username, String passwordHash, String email) {
        super(id, username, passwordHash, Role.ADMIN, email);
    }
    @Override public void updateProfile(Profile profile) { /* optional */ }
}
