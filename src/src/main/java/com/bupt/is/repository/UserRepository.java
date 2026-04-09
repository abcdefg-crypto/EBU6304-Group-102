package com.bupt.is.repository;

import com.bupt.is.model.User;
import java.util.List;

public interface UserRepository {

    void save(User user);

    User findById(String id);

    User findByUsername(String username);

    List<User> findAll();

    void update(User user);

    void delete(String id);
}
