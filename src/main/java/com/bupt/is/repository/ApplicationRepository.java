package com.bupt.is.repository;

import com.bupt.is.model.Application;
import java.util.List;

public interface ApplicationRepository {

    void save(Application application);

    Application findById(String applicationId);

    List<Application> findByUser(String userId);

    List<Application> findByJob(String jobId);

    List<Application> findAll();

    void update(Application application);
}
