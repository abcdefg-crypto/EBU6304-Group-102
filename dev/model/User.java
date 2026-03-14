package dev.model;
import java.util.*;

//用户抽象类
public abstract class User {
    protected String id;
    protected String username;
    protected String passwordHash;
    protected Role role;
    protected String email;

    public User() {}

    public User(String id, String username, String passwordHash, Role role, String email) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.role = role;
        this.email = email;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public abstract void updateProfile(Profile profile);

    public boolean checkPassword(String plainPassword) {
        // TODO: 调用密码校验工具（PBKDF2/BCrypt 等）
        return false;
    }
}










