package com.bupt.is.service;

import com.bupt.is.model.User;

public interface AuthService {

    User login(String username, String password);

    User register(User user);

    boolean validateUser(User user);
}
