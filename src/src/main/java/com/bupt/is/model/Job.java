package com.bupt.is.model;

import java.util.List;

public class Job {

    private String jobId;
    private String title;
    private String description;
    private String module;
    private String postedBy;

    private List<String> requiredSkills;
    private int maxApplicants;
    private String status;

    public Job() {}

    // ===== Getter & Setter =====
    public String getJobId() { return jobId; }
    public void setJobId(String jobId) { this.jobId = jobId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }

    public String getPostedBy() { return postedBy; }
    public void setPostedBy(String postedBy) { this.postedBy = postedBy; }

    public List<String> getRequiredSkills() { return requiredSkills; }
    public void setRequiredSkills(List<String> requiredSkills) { this.requiredSkills = requiredSkills; }

    public int getMaxApplicants() { return maxApplicants; }
    public void setMaxApplicants(int maxApplicants) { this.maxApplicants = maxApplicants; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // ===== Business Methods =====
    public boolean isOpen() {
        return "OPEN".equalsIgnoreCase(status);
    }

    public void closeJob() {
        this.status = "CLOSED";
    }

    public void addRequiredSkill(String skill) {
        requiredSkills.add(skill);
    }
}