package com.bupt.is.service.impl;

import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import com.bupt.is.repository.JobRepository;
import com.bupt.is.repository.impl.FileJobRepository;
import com.bupt.is.service.JobService;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class JobServiceImpl implements JobService {

    private final JobRepository jobRepository = new FileJobRepository();

    @Override
    public void postJob(Job job, User mo) {
        if (job == null) {
            throw new IllegalArgumentException("job is required");
        }
        if (mo == null || mo.getId() == null) {
            throw new IllegalArgumentException("mo is required");
        }
        if (isBlank(job.getTitle()) || isBlank(job.getDescription()) || isBlank(job.getModule())) {
            throw new IllegalArgumentException("title/description/module are required");
        }
        if (job.getMaxApplicants() <= 0) {
            throw new IllegalArgumentException("maxApplicants must be > 0");
        }
        if (job.getRequiredSkills() == null || job.getRequiredSkills().isEmpty()) {
            throw new IllegalArgumentException("requiredSkills are required");
        }

        if (job.getJobId() == null) {
            job.setJobId(com.bupt.is.util.IdGenerator.generateJobId());
        }

        job.setPostedBy(mo.getId());
        job.setStatus("OPEN");
        jobRepository.save(job);
    }

    @Override
    public void updateJob(Job job, User mo) {
        if (job == null || isBlank(job.getJobId())) {
            throw new IllegalArgumentException("job with id is required");
        }
        if (mo == null || mo.getId() == null) {
            throw new IllegalArgumentException("mo is required");
        }
        Job existing = jobRepository.findById(job.getJobId());
        if (existing == null) {
            throw new IllegalArgumentException("job not found");
        }
        if (!Objects.equals(existing.getPostedBy(), mo.getId())) {
            throw new IllegalArgumentException("only the posting MO can update this job");
        }
        if (isBlank(job.getTitle()) || isBlank(job.getDescription()) || isBlank(job.getModule())) {
            throw new IllegalArgumentException("title/description/module are required");
        }
        if (job.getMaxApplicants() <= 0) {
            throw new IllegalArgumentException("maxApplicants must be > 0");
        }
        if (job.getRequiredSkills() == null || job.getRequiredSkills().isEmpty()) {
            throw new IllegalArgumentException("requiredSkills are required");
        }

        job.setPostedBy(existing.getPostedBy());
        job.setStatus(existing.getStatus());
        jobRepository.update(job);
    }

    @Override
    public List<Job> getAvailableJobs() {
        return jobRepository.findOpenJobs();
    }

    @Override
    public Job getJobById(String jobId) {
        if (isBlank(jobId)) {
            return null;
        }
        return jobRepository.findById(jobId);
    }

    @Override
    public void closeJob(String jobId) {
        Job job = getJobById(jobId);
        if (job == null) {
            throw new IllegalArgumentException("job not found");
        }
        job.closeJob();
        jobRepository.update(job);
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

