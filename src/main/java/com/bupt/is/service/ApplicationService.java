package com.bupt.is.service;

import com.bupt.is.model.Application;
import java.util.List;

public interface ApplicationService {

    void applyJob(String userId, String jobId, String cvPath);

    List<Application> getUserApplications(String userId);

    Application getApplicationById(String appId);

    void updateStatus(String appId, String status, String reason);

    void withdrawApplication(String userId, String appId);

    List<Application> getApplicantsForJob(String jobId);
}
