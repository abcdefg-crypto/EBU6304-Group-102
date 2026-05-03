package com.bupt.is.service.impl;

import com.bupt.is.model.Application;
import com.bupt.is.model.User;
import com.bupt.is.repository.ApplicationRepository;
import com.bupt.is.repository.UserRepository;
import com.bupt.is.repository.impl.FileApplicationRepository;
import com.bupt.is.repository.impl.FileUserRepository;
import com.bupt.is.service.AdminService;

import java.util.*;

public class AdminServiceImpl implements AdminService {

    private final ApplicationRepository applicationRepository = new FileApplicationRepository();
    private final UserRepository userRepository = new FileUserRepository();

    @Override
    public int calculateWorkload(String userId) {
        List<Application> apps = applicationRepository.findByUser(userId);
        int count = 0;
        for (Application a : apps) {
            if ("ACCEPTED".equalsIgnoreCase(a.getStatus())) {
                count++;
            }
        }
        return count;
    }

    @Override
    public Map<String, Integer> getAllWorkloads() {
        Map<String, Integer> workloads = new LinkedHashMap<>();
        List<User> allUsers = userRepository.findAll();
        for (User u : allUsers) {
            if (u.hasRole("TA")) {
                workloads.put(u.getId(), calculateWorkload(u.getId()));
            }
        }
        return workloads;
    }

    @Override
    public List<String> getOverloadedUsers() {
        Map<String, Integer> workloads = getAllWorkloads();
        if (workloads.isEmpty()) return List.of();

        double avg = workloads.values().stream().mapToInt(Integer::intValue).average().orElse(0);
        List<String> overloaded = new ArrayList<>();
        for (Map.Entry<String, Integer> e : workloads.entrySet()) {
            if (e.getValue() > avg + 1) {
                overloaded.add(e.getKey());
            }
        }
        return overloaded;
    }
}
