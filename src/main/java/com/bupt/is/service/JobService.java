package com.bupt.is.service;

import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import java.util.List;

public interface JobService {

    void postJob(Job job, User mo);

    void updateJob(Job job, User mo);

    List<Job> getAvailableJobs();

    List<Job> searchAvailableJobs(String keyword);

    List<Job> getAllJobs();

    List<Job> searchAllJobs(String keyword);

    Job getJobById(String jobId);

    void closeJob(String jobId, User mo);
}
