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

        // Prevent duplicates: same title + same module (case-insensitive, trimmed).
        // This avoids confusing "same job posted twice" situations.
        if (existsSameTitleAndModule(null, job.getTitle(), job.getModule())) {
            throw new IllegalArgumentException("A job with the same Job Title and Module already exists. Please change the Job Title or Module.");
        }

        job.setPostedBy(mo.getId());
        job.setStatus("ACTIVE");
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

        if (existsSameTitleAndModule(job.getJobId(), job.getTitle(), job.getModule())) {
            throw new IllegalArgumentException("A job with the same Job Title and Module already exists. Please change the Job Title or Module.");
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
    public List<Job> searchAvailableJobs(String keyword) {
        if (isBlank(keyword)) {
            return getAvailableJobs();
        }
        return jobRepository.searchOpenJobs(keyword);
    }

    @Override
    public List<Job> getAllJobs() {
        return jobRepository.findAll();
    }

    @Override
    public List<Job> searchAllJobs(String keyword) {
        if (isBlank(keyword)) {
            return getAllJobs();
        }
        String normalized = keyword.trim().toLowerCase();
        List<Job> matches = new ArrayList<>();
        for (Job job : jobRepository.findAll()) {
            if (job == null) {
                continue;
            }
            if (contains(job.getTitle(), normalized)
                    || contains(job.getModule(), normalized)
                    || contains(job.getDescription(), normalized)
                    || containsSkills(job, normalized)) {
                matches.add(job);
            }
        }
        return matches;
    }

    @Override
    public Job getJobById(String jobId) {
        if (isBlank(jobId)) {
            return null;
        }
        return jobRepository.findById(jobId);
    }

    @Override
    public void closeJob(String jobId, User mo) {
        if (mo == null || isBlank(mo.getId())) {
            throw new IllegalArgumentException("mo is required");
        }
        Job job = getJobById(jobId);
        if (job == null) {
            throw new IllegalArgumentException("job not found");
        }
        if (!Objects.equals(job.getPostedBy(), mo.getId())) {
            throw new IllegalArgumentException("only the posting MO can close this job");
        }
        if (!job.isOpen()) {
            throw new IllegalArgumentException("job is already closed");
        }
        job.closeJob();
        jobRepository.update(job);
    }

    private static boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase().contains(keyword);
    }

    private static boolean containsSkills(Job job, String keyword) {
        if (job.getRequiredSkills() == null) {
            return false;
        }
        for (String skill : job.getRequiredSkills()) {
            if (contains(skill, keyword)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean existsSameTitleAndModule(String excludeJobId, String title, String module) {
        String t = title == null ? "" : title.trim().toLowerCase();
        String m = module == null ? "" : module.trim().toLowerCase();
        if (t.isEmpty() || m.isEmpty()) {
            return false;
        }
        for (Job j : jobRepository.findAll()) {
            if (j == null) {
                continue;
            }
            if (excludeJobId != null && Objects.equals(excludeJobId, j.getJobId())) {
                continue;
            }
            String jt = j.getTitle() == null ? "" : j.getTitle().trim().toLowerCase();
            String jm = j.getModule() == null ? "" : j.getModule().trim().toLowerCase();
            if (t.equals(jt) && m.equals(jm)) {
                return true;
            }
        }
        return false;
    }
}

