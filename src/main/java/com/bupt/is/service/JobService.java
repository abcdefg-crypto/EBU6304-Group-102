package com.bupt.is.service;

import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import java.util.List;

public interface JobService {

    void postJob(Job job, User mo);

    List<Job> getAvailableJobs();

    Job getJobById(String jobId);

    void closeJob(String jobId);
}
