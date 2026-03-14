
package dev.auth;

import dev.model.*;
import java.util.*;


//在服务器端保存会话与过期管理
public class SessionManager {
    private Map<String, SessionInfo> sessions = new HashMap<>();
    public SessionInfo createSession(User user) {
        String sid = java.util.UUID.randomUUID().toString();
        SessionInfo s = new SessionInfo(sid, user.getId());
        sessions.put(sid, s);
        return s;
    }
    public SessionInfo getSession(String sessionId) { return sessions.get(sessionId); }
    public void invalidate(String sessionId) { sessions.remove(sessionId); }
}
