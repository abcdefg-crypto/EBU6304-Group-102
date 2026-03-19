package com.bupt.is.service.impl;

import com.bupt.is.model.User;
import com.bupt.is.repository.UserRepository;
import com.bupt.is.repository.impl.FileUserRepository;
import com.bupt.is.service.AuthService;
import com.bupt.is.util.IdGenerator;

import java.util.Collections;

public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository = new FileUserRepository();

    @Override
    public User login(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            return null;
        }
        return user.checkPassword(password) ? user : null;
    }

    @Override
    public User register(User user) {
        if (user.getId() == null) {
            user.setId(IdGenerator.generateUserId());
        }
        if (user.getRoles() == null) {
            user.setRoles(Collections.singletonList("TA"));
        }
        userRepository.save(user);
        return user;
    }

    @Override
    public boolean validateUser(User user) {
        return user != null && user.getUsername() != null && user.getPassword() != null;
    }
}

