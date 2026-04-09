package com.bupt.is.model;

public class ApplicantCV {
    private String applicantId;
    private String applicantUsername;
    private String cvPath;
    private String applicationId;

    public ApplicantCV() {
    }

    public ApplicantCV(String applicantId, String applicantUsername, String cvPath, String applicationId) {
        this.applicantId = applicantId;
        this.applicantUsername = applicantUsername;
        this.cvPath = cvPath;
        this.applicationId = applicationId;
    }

    public String getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(String applicantId) {
        this.applicantId = applicantId;
    }

    public String getApplicantUsername() {
        return applicantUsername;
    }

    public void setApplicantUsername(String applicantUsername) {
        this.applicantUsername = applicantUsername;
    }

    public String getCvPath() {
        return cvPath;
    }

    public void setCvPath(String cvPath) {
        this.cvPath = cvPath;
    }

    public String getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(String applicationId) {
        this.applicationId = applicationId;
    }
}

