package com.bupt.is.service;

import java.util.List;
import java.util.Map;

public interface AdminService {

    int calculateWorkload(String userId);

    Map<String, Integer> getAllWorkloads();

    List<String> getOverloadedUsers();
}
