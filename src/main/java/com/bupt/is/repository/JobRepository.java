package com.bupt.is.repository;

import com.bupt.is.model.Job;
import java.util.List;

public interface JobRepository {

    void save(Job job);

    Job findById(String id);

    List<Job> findAll();

    List<Job> findOpenJobs();

    void update(Job job);
}
