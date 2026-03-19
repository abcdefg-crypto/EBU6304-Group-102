package com.bupt.is.model;

public class Application {

    private String applicationId;
    private String jobId;
    private String applicantId;

    private String status;
    private String cvPath;
    private int score;

    public Application() {}

    // ===== Getter & Setter =====
    public String getApplicationId() { return applicationId; }
    public void setApplicationId(String applicationId) { this.applicationId = applicationId; }

    public String getJobId() { return jobId; }
    public void setJobId(String jobId) { this.jobId = jobId; }

    public String getApplicantId() { return applicantId; }
    public void setApplicantId(String applicantId) { this.applicantId = applicantId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCvPath() { return cvPath; }
    public void setCvPath(String cvPath) { this.cvPath = cvPath; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    // ===== Business Methods =====
    public void updateStatus(String status) {
        this.status = status;
    }

    public boolean isAccepted() {
        return "ACCEPTED".equalsIgnoreCase(status);
    }
}
