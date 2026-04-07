package com.bupt.is.model;

public class ApplicationView {
    private final String applicationId;
    private final String jobId;
    private final String jobTitle;
    private final String module;
    private final String status;

    public ApplicationView(String applicationId, String jobId, String jobTitle, String module, String status) {
        this.applicationId = applicationId;
        this.jobId = jobId;
        this.jobTitle = jobTitle;
        this.module = module;
        this.status = status;
    }

    public String getApplicationId() {
        return applicationId;
    }

    public String getJobId() {
        return jobId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public String getModule() {
        return module;
    }

    public String getStatus() {
        return status;
    }
}
