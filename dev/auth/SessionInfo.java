// ==================== auth/SessionManager.java ====================
package dev.auth;

import java.util.*;
//服务器端信息
public class SessionInfo {
    private String sessionId;
    private String userId;
    private Date createdAt;
    public SessionInfo(String sessionId, String userId) { this.sessionId = sessionId; this.userId = userId; this.createdAt = new Date(); }
    public String getSessionId() { return sessionId; }
    public String getUserId() { return userId; }
}