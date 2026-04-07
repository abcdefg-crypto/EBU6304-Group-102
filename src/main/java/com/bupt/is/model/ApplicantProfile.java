package com.bupt.is.model;

/**
 * Applicant profile is stored inside {@link User#profile} as JSON string.
 */
public class ApplicantProfile {
    private String name;
    private String studentId;
    private String phoneNumber;
    private String skills;
    private String selfIntroduction;

    public ApplicantProfile() {
    }

    public ApplicantProfile(String name, String studentId, String phoneNumber, String skills, String selfIntroduction) {
        this.name = name;
        this.studentId = studentId;
        this.phoneNumber = phoneNumber;
        this.skills = skills;
        this.selfIntroduction = selfIntroduction;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getSelfIntroduction() {
        return selfIntroduction;
    }

    public void setSelfIntroduction(String selfIntroduction) {
        this.selfIntroduction = selfIntroduction;
    }
}