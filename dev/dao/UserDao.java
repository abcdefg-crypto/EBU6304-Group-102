package dev.dao;

import dev.model.*;
import java.util.*;
//用户DAO接口
public interface UserDao {
    Optional<User> findByUsername(String username);
    Optional<User> findById(String id);
    List<User> findAll();
    void save(User user) throws Exception;
    void update(User user) throws Exception;
}