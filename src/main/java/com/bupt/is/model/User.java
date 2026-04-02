package com.bupt.is.model;

import java.util.List;

public class User {

    private String id;
    private String username;
    private String password;
    private String email;
    private List<String> roles;

    private String profile;
    // Relative to ./data/, e.g. "cv/USER_001.pdf"
    private String cvPath;
    private List<String> skills;
    private int workload;

    public User() {}

    public User(String id, String username, String password, String email, List<String> roles) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.roles = roles;
    }

    // ===== Getter & Setter =====
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public List<String> getRoles() { return roles; }
    public void setRoles(List<String> roles) { this.roles = roles; }

    public String getProfile() { return profile; }
    public void setProfile(String profile) { this.profile = profile; }

    public String getCvPath() { return cvPath; }
    public void setCvPath(String cvPath) { this.cvPath = cvPath; }

    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = skills; }

    public int getWorkload() { return workload; }
    public void setWorkload(int workload) { this.workload = workload; }

    // ===== Business Methods =====
    public boolean hasRole(String role) {
        return roles != null && roles.contains(role);
    }

    public void addRole(String role) {
        if (!roles.contains(role)) {
            roles.add(role);
        }
    }

    public void removeRole(String role) {
        roles.remove(role);
    }

    public void addSkill(String skill) {
        skills.add(skill);
    }

    public boolean checkPassword(String inputPassword) {
        return this.password.equals(inputPassword);
    }
}
