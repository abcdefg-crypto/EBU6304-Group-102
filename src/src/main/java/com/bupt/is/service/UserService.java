package com.bupt.is.service;

import com.bupt.is.model.User;

public interface UserService {

    User createProfile(User user);

    User updateProfile(User user);

    User findById(String id);

    User findByUsername(String username);

    void uploadCv(String userId, String cvPath);
}

