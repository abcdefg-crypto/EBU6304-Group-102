package com.bupt.is.repository.impl;

import com.bupt.is.model.User;
import com.bupt.is.repository.UserRepository;
import com.bupt.is.util.FileService;
import com.bupt.is.util.GsonUtil;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import com.google.gson.reflect.TypeToken;

public class FileUserRepository implements UserRepository {

    private static final String FILE_NAME = "users.json";

    private List<User> loadAll() {
        String json = FileService.readFile(FILE_NAME);
        Type type = new TypeToken<List<User>>() {}.getType();
        List<User> users = GsonUtil.fromJsonList(json, type);
        return users != null ? users : new ArrayList<>();
    }

    private void saveAll(List<User> users) {
        String json = GsonUtil.toJson(users);
        FileService.writeFile(FILE_NAME, json);
    }

    @Override
    public void save(User user) {
        List<User> users = loadAll();
        users.add(user);
        saveAll(users);
    }

    @Override
    public User findById(String id) {
        return loadAll().stream()
                .filter(u -> Objects.equals(u.getId(), id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public User findByUsername(String username) {
        return loadAll().stream()
                .filter(u -> Objects.equals(u.getUsername(), username))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<User> findAll() {
        return new ArrayList<>(loadAll());
    }

    @Override
    public void update(User user) {
        List<User> users = loadAll()
                .stream()
                .map(u -> Objects.equals(u.getId(), user.getId()) ? user : u)
                .collect(Collectors.toList());
        saveAll(users);
    }

    @Override
    public void delete(String id) {
        List<User> users = loadAll()
                .stream()
                .filter(u -> !Objects.equals(u.getId(), id))
                .collect(Collectors.toList());
        saveAll(users);
    }
}

