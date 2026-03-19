package com.bupt.is.service;

import com.bupt.is.model.Application;
import java.util.List;

public interface ApplicationService {

    void applyJob(String userId, String jobId, String cvPath);

    List<Application> getUserApplications(String userId);

    void updateStatus(String appId, String status);

    List<Application> getApplicantsForJob(String jobId);
}
