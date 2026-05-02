package com.bupt.is.repository.impl;

import com.bupt.is.model.Job;
import com.bupt.is.repository.JobRepository;
import com.bupt.is.util.FileService;
import com.bupt.is.util.GsonUtil;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class FileJobRepository implements JobRepository {

    private static final String FILE_NAME = "jobs.json";

    private List<Job> loadAll() {
        String json = FileService.readFile(FILE_NAME);
        Type type = new TypeToken<List<Job>>() {}.getType();
        List<Job> jobs = GsonUtil.fromJsonList(json, type);
        return jobs != null ? jobs : new ArrayList<>();
    }

    private void saveAll(List<Job> jobs) {
        String json = GsonUtil.toJson(jobs);
        FileService.writeFile(FILE_NAME, json);
    }

    @Override
    public void save(Job job) {
        List<Job> jobs = loadAll();
        jobs.add(job);
        saveAll(jobs);
    }

    @Override
    public Job findById(String id) {
        return loadAll().stream()
                .filter(j -> Objects.equals(j.getJobId(), id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Job> findAll() {
        return new ArrayList<>(loadAll());
    }

    @Override
    public List<Job> findOpenJobs() {
        return loadAll().stream()
                .filter(Job::isOpen)
                .collect(Collectors.toList());
    }

    @Override
    public List<Job> searchOpenJobs(String keyword) {
        String normalized = keyword == null ? "" : keyword.trim().toLowerCase();
        return loadAll().stream()
                .filter(Job::isOpen)
                .filter(job -> contains(job.getTitle(), normalized)
                        || contains(job.getModule(), normalized)
                        || contains(job.getDescription(), normalized)
                        || containsSkills(job, normalized))
                .collect(Collectors.toList());
    }

    private static boolean contains(String value, String keyword) {
        return value != null && value.toLowerCase().contains(keyword);
    }

    private static boolean containsSkills(Job job, String keyword) {
        if (job.getRequiredSkills() == null) {
            return false;
        }
        return job.getRequiredSkills().stream().anyMatch(skill -> contains(skill, keyword));
    }

    @Override
    public void update(Job job) {
        List<Job> jobs = loadAll().stream()
                .map(j -> Objects.equals(j.getJobId(), job.getJobId()) ? job : j)
                .collect(Collectors.toList());
        saveAll(jobs);
    }
}

