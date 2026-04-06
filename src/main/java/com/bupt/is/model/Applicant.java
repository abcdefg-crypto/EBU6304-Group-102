package com.bupt.is.model;

import java.io.Serializable;

/**
 * 申请者POJO类：封装申请者基础信息和简历文件关联
 */
public class Applicant implements Serializable {
    // 序列化版本号（保证文件读写一致性）
    private static final long serialVersionUID = 1L;

    // 核心字段
    private String applicantId; // 申请者唯一ID
    private String jobPostingId; // 关联的岗位ID
    private String name; // 姓名
    private String profile; // 个人简介
    private String cvFilePath; // 简历文件存储路径（仅存路径，不存文件内容）

    // 无参构造（反序列化/反射必备）
    public Applicant() {
    }

    // 全参构造
    public Applicant(String applicantId, String jobPostingId, String name, String profile, String cvFilePath) {
        this.applicantId = applicantId;
        this.jobPostingId = jobPostingId;
        this.name = name;
        this.profile = profile;
        this.cvFilePath = cvFilePath;
    }

    // Getter & Setter（必须，保证各层能访问字段）
    public String getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(String applicantId) {
        this.applicantId = applicantId;
    }

    public String getJobPostingId() {
        return jobPostingId;
    }

    public void setJobPostingId(String jobPostingId) {
        this.jobPostingId = jobPostingId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProfile() {
        return profile;
    }

    public void setProfile(String profile) {
        this.profile = profile;
    }

    public String getCvFilePath() {
        return cvFilePath;
    }

    public void setCvFilePath(String cvFilePath) {
        this.cvFilePath = cvFilePath;
    }
}