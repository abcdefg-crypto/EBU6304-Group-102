package dev.model;

import java.util.List;
import java.util.ArrayList;

//申请人类
public class Applicant extends User {
    private Profile profile;
    private List<Skill> skills = new ArrayList<>();
    private List<String> applicationIds = new ArrayList<>();
    private int currentLoad = 0;

    public Applicant() { this.role = Role.APPLICANT; }

    public Applicant(String id, String username, String passwordHash, String email) {
        super(id, username, passwordHash, Role.APPLICANT, email);
    }

    @Override
    public void updateProfile(Profile profile) { this.profile = profile; }

    public Profile getProfile() { return profile; }
    public void setProfile(Profile profile) { this.profile = profile; }

    public List<Skill> getSkills() { return skills; }
    public void setSkills(List<Skill> skills) { this.skills = skills; }

    public int getCurrentLoad() { return currentLoad; }
    public void setCurrentLoad(int currentLoad) { this.currentLoad = currentLoad; }

    public List<String> getApplicationIds() { return applicationIds; }
}

