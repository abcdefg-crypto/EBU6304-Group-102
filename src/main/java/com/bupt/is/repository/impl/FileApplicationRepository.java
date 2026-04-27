package com.bupt.is.repository.impl;

import com.bupt.is.model.Application;
import com.bupt.is.repository.ApplicationRepository;
import com.bupt.is.util.FileService;
import com.bupt.is.util.GsonUtil;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class FileApplicationRepository implements ApplicationRepository {

    private static final String FILE_NAME = "applications.json";

    private List<Application> loadAll() {
        String json = FileService.readFile(FILE_NAME);
        Type type = new TypeToken<List<Application>>() {}.getType();
        List<Application> apps = GsonUtil.fromJsonList(json, type);
        return apps != null ? apps : new ArrayList<>();
    }

    private void saveAll(List<Application> applications) {
        String json = GsonUtil.toJson(applications);
        FileService.writeFile(FILE_NAME, json);
    }

    @Override
    public void save(Application application) {
        List<Application> apps = loadAll();
        apps.add(application);
        saveAll(apps);
    }

    @Override
    public Application findById(String applicationId) {
        return loadAll().stream()
                .filter(a -> Objects.equals(a.getApplicationId(), applicationId))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Application> findByUser(String userId) {
        return loadAll().stream()
                .filter(a -> Objects.equals(a.getApplicantId(), userId))
                .collect(Collectors.toList());
    }

    @Override
    public List<Application> findByJob(String jobId) {
        return loadAll().stream()
                .filter(a -> Objects.equals(a.getJobId(), jobId))
                .collect(Collectors.toList());
    }

    @Override
    public void update(Application application) {
        List<Application> apps = loadAll().stream()
                .map(a -> Objects.equals(a.getApplicationId(), application.getApplicationId()) ? application : a)
                .collect(Collectors.toList());
        saveAll(apps);
    }

    @Override
    public void deleteById(String applicationId) {
        List<Application> apps = loadAll().stream()
                .filter(a -> !Objects.equals(a.getApplicationId(), applicationId))
                .collect(Collectors.toList());
        saveAll(apps);
    }
}

