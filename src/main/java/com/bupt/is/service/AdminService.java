package com.bupt.is.service;

import com.bupt.is.model.Application;
import java.util.List;
import java.util.Map;

public interface AdminService {

    int calculateWorkload(String userId);

    Map<String, Integer> getAllWorkloads();

    List<Application> getAllApplications();

    List<String> getOverloadedUsers();
}
