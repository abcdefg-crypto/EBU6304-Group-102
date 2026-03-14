package dev.model;

import java.util.*;


//应聘者申请职位类
public class Application {
    private String id;
    private String jobId;
    private String applicantId;
    private ApplicationStatus status;
    private String coverLetter;
    private Date appliedAt;
    private double matchScore;

    public Application() {}
    public Application(String id, String jobId, String applicantId) {
        this.id = id; this.jobId = jobId; this.applicantId = applicantId; this.appliedAt = new Date(); this.status = ApplicationStatus.APPLIED;
    }
    // getters/setters
}

