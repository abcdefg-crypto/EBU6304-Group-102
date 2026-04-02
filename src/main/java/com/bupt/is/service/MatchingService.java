package com.bupt.is.service;

import com.bupt.is.model.Job;
import com.bupt.is.model.User;
import java.util.List;

public interface MatchingService {

    int calculateMatchScore(User user, Job job);

    List<Job> recommendJobs(User user);
}
