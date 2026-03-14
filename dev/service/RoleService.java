package dev.service;

import dev.model.*;

public class RoleService {
    public boolean authorize(User user, String action, String resource) {
        // TODO: 简单 RBAC 校验
        return true;
    }
}