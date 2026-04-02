package com.bupt.is.service.impl;

import com.bupt.is.model.ApplicantProfile;
import com.bupt.is.model.User;
import com.bupt.is.repository.UserRepository;
import com.bupt.is.repository.impl.FileUserRepository;
import com.bupt.is.service.UserService;
import com.bupt.is.util.GsonUtil;
import com.bupt.is.util.IdGenerator;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class UserServiceImpl implements UserService {

    private final UserRepository userRepository = new FileUserRepository();

    @Override
    public User createProfile(User user) {
        if (user == null) {
            throw new IllegalArgumentException("user is required");
        }
        if (isBlank(user.getUsername()) || isBlank(user.getPassword()) || isBlank(user.getEmail())) {
            throw new IllegalArgumentException("username/password/email are required");
        }

        ApplicantProfile profile = parseApplicantProfile(user.getProfile());
        if (profile == null || isBlank(profile.getName()) || isBlank(profile.getStudentId())) {
            throw new IllegalArgumentException("profile.name & profile.studentId are required");
        }

        if (user.getRoles() == null || user.getRoles().isEmpty()) {
            user.setRoles(List.of("TA"));
        }

        if (user.getId() == null) {
            user.setId(IdGenerator.generateUserId());
        }

        // Basic duplicate check by username.
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new IllegalArgumentException("username already exists");
        }

        // Normalize roles to upper case for consistent UI.
        user.setRoles(normalizeRoles(user.getRoles()));

        userRepository.save(user);
        return user;
    }

    @Override
    public User updateProfile(User user) {
        if (user == null || isBlank(user.getId())) {
            throw new IllegalArgumentException("user.id is required");
        }
        User existing = userRepository.findById(user.getId());
        if (existing == null) {
            throw new IllegalArgumentException("user not found");
        }

        existing.setEmail(user.getEmail());
        ApplicantProfile profile = parseApplicantProfile(user.getProfile());
        existing.setProfile(GsonUtil.toJson(profile));

        userRepository.update(existing);
        return existing;
    }

    @Override
    public User findById(String id) {
        return userRepository.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public void uploadCv(String userId, String cvPath) {
        if (isBlank(userId)) {
            throw new IllegalArgumentException("userId is required");
        }
        User existing = userRepository.findById(userId);
        if (existing == null) {
            throw new IllegalArgumentException("user not found");
        }
        existing.setCvPath(cvPath);
        userRepository.update(existing);
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static ApplicantProfile parseApplicantProfile(String profileJson) {
        if (isBlank(profileJson)) {
            return null;
        }
        try {
            return GsonUtil.fromJson(profileJson, ApplicantProfile.class);
        } catch (Exception e) {
            return null;
        }
    }

    private static List<String> normalizeRoles(List<String> roles) {
        List<String> out = new ArrayList<>();
        for (String r : roles) {
            if (!isBlank(r)) {
                out.add(r.trim().toUpperCase());
            }
        }
        // Ensure list isn't empty.
        return out.isEmpty() ? List.of("TA") : out;
    }
}

