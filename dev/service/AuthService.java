package dev.service;

import dev.model.*;
import dev.dao.*;
import dev.exception.*;
import dev.auth.*;
//登入登出服务类
public class AuthService {
    private UserDao userDao;
    private SessionManager sessionManager;

    public AuthService(UserDao userDao, SessionManager sessionManager) { this.userDao = userDao; this.sessionManager = sessionManager; }

    public SessionInfo login(String username, String password) throws AuthenticationException {
        // TODO: 查询用户 -> 验证密码 -> 创建会话
        return null;
    }

    public void logout(String sessionId) { sessionManager.invalidate(sessionId); }

    public User registerApplicant(String username, String password, String email) throws Exception {
        // TODO: 验证、哈希密码、持久化
        return null;
    }
}