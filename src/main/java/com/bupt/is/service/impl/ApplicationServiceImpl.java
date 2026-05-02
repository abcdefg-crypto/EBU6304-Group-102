package com.bupt.is.service.impl;

import com.bupt.is.model.Application;
import com.bupt.is.model.Job;
import com.bupt.is.repository.ApplicationRepository;
import com.bupt.is.repository.JobRepository;
import com.bupt.is.repository.impl.FileApplicationRepository;
import com.bupt.is.repository.impl.FileJobRepository;
import com.bupt.is.service.ApplicationService;
import com.bupt.is.util.IdGenerator;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

public class ApplicationServiceImpl implements ApplicationService {

    private final ApplicationRepository applicationRepository = new FileApplicationRepository();
    private final JobRepository jobRepository = new FileJobRepository();

    @Override
    public void applyJob(String userId, String jobId, String cvPath) {
        if (isBlank(userId) || isBlank(jobId)) {
            throw new IllegalArgumentException("userId/jobId are required");
        }
        if (isBlank(cvPath)) {
            throw new IllegalArgumentException("CV must be uploaded before applying");
        }

        Job job = jobRepository.findById(jobId);
        if (job == null) {
            throw new IllegalArgumentException("job not found");
        }
        if (!job.isOpen()) {
            throw new IllegalArgumentException("This job has been closed and no longer accepts new applications");
        }

        // Duplicate application check.
        List<Application> myApps = applicationRepository.findByUser(userId);
        for (Application a : myApps) {
            if (Objects.equals(jobId, a.getJobId())) {
                throw new IllegalArgumentException("You have already applied for this job");
            }
        }

        Application app = new Application();
        app.setApplicationId(IdGenerator.generateApplicationId());
        app.setApplicantId(userId);
        app.setJobId(jobId);
        app.setStatus("PENDING");
        app.setCvPath(cvPath);
        app.setAppliedAt(LocalDate.now().toString());
        app.setScore(0);

        applicationRepository.save(app);
    }

    @Override
    public List<Application> getUserApplications(String userId) {
        return applicationRepository.findByUser(userId);
    }

    @Override
    public Application getApplicationById(String appId) {
        if (isBlank(appId)) {
            return null;
        }
        return applicationRepository.findById(appId);
    }

    @Override
    public void updateStatus(String appId, String status, String reason) {
        if (isBlank(appId) || isBlank(status)) {
            throw new IllegalArgumentException("appId/status are required");
        }
        String normalizedStatus = status.trim().toUpperCase();
        if (!"PENDING".equals(normalizedStatus)
                && !"ACCEPTED".equals(normalizedStatus)
                && !"REJECTED".equals(normalizedStatus)) {
            throw new IllegalArgumentException("status must be pending/accepted/rejected");
        }
        Application existing = applicationRepository.findById(appId);
        if (existing == null) {
            throw new IllegalArgumentException("application not found");
        }
        existing.updateStatus(normalizedStatus);
        if ("REJECTED".equals(normalizedStatus)) {
            existing.setRejectionReason(isBlank(reason) ? "未填写拒绝原因" : reason.trim());
        } else {
            existing.setRejectionReason(null);
        }
        applicationRepository.update(existing);
    }

    @Override
    public List<Application> getApplicantsForJob(String jobId) {
        if (isBlank(jobId)) {
            return List.of();
        }
        return applicationRepository.findByJob(jobId);
    }

    @Override
    public List<Application> getAllApplications() {
        return applicationRepository.findAll();
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

