package com.bupt.is.model;

/**
 * One row for the admin "all applications" monitor view.
 */
public class AdminApplicationRow {

    private String applicationId;
    private String jobId;
    private String jobTitle;
    private String jobModule;
    private String applicantId;
    private String applicantDisplayName;
    private String status;
    private String appliedAt;
    private int score;
    private String cvPath;

    public String getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(String applicationId) {
        this.applicationId = applicationId;
    }

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobModule() {
        return jobModule;
    }

    public void setJobModule(String jobModule) {
        this.jobModule = jobModule;
    }

    public String getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(String applicantId) {
        this.applicantId = applicantId;
    }

    public String getApplicantDisplayName() {
        return applicantDisplayName;
    }

    public void setApplicantDisplayName(String applicantDisplayName) {
        this.applicantDisplayName = applicantDisplayName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(String appliedAt) {
        this.appliedAt = appliedAt;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getCvPath() {
        return cvPath;
    }

    public void setCvPath(String cvPath) {
        this.cvPath = cvPath;
    }
}
