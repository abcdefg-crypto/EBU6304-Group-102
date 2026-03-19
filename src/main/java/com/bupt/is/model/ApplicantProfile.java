package com.bupt.is.model;

/**
 * Applicant profile is stored inside {@link User#profile} as JSON string.
 */
public class ApplicantProfile {
    private String name;
    private String studentId;

    public ApplicantProfile() {
    }

    public ApplicantProfile(String name, String studentId) {
        this.name = name;
        this.studentId = studentId;
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
}

