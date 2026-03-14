//应聘者被分配到职位类
package dev.model;

import java.util.*;

public class Assignment {
    private String id;
    private String jobId;
    private String applicantId;
    private Date assignedAt;

    public Assignment() {}
    public Assignment(String id, String jobId, String applicantId) { this.id = id; this.jobId = jobId; this.applicantId = applicantId; this.assignedAt = new Date(); }
    // getters/setters
}