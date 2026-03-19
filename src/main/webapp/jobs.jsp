<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>岗位列表 - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header {
            background: #1f3c88; color: #fff; padding: 14px 24px;
            display: flex; justify-content: space-between; align-items: center;
        }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        h2 { margin: 0 0 12px; font-size: 16px; }
        .messages { margin-bottom: 14px; }
        .success { background: #dcfce7; color: #166534; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 14px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        .card h3 { margin: 0 0 8px; font-size: 15px; color: #111827; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; margin-right: 6px; }
        .btn { border-radius: 999px; padding: 8px 14px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 13px; text-decoration:none; display:inline-block; margin-top: 8px; }
        .btn-primary { border: none; background:#2563eb; color:#fff; }
        ul { margin: 6px 0 0 18px; padding: 0; }
        li { color:#4b5563; font-size: 13px; margin-bottom: 4px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>岗位列表</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">
            角色：<%= request.getAttribute("role") %>
        </span>
    </div>
    <div>
        <%
            String role = (String) request.getAttribute("role");
        %>
        <% if ("TA".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/user/profile">我的档案/CV</a>
        <% } %>
        <% if ("MO".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/jobs/post">发布岗位</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <div class="messages">
        <%
            String applied = request.getParameter("applied");
            String posted = request.getParameter("posted");
        %>
        <% if ("1".equals(applied)) { %>
            <div class="success">申请已提交（Story8）</div>
        <% } %>
        <% if ("1".equals(posted)) { %>
            <div class="success">岗位已发布（Story13）</div>
        <% } %>
    </div>

    <h2>可用岗位（OPEN）</h2>
    <div class="grid">
        <%
            java.util.List<com.bupt.is.model.Job> jobs = (java.util.List<com.bupt.is.model.Job>) request.getAttribute("jobs");
            if (jobs == null || jobs.isEmpty()) {
        %>
            <div class="card" style="grid-column: 1 / -1;">
                <div class="meta">暂无岗位。请 MO 登录后发布岗位。</div>
                <%
                    if ("MO".equals(role)) {
                %>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/jobs/post">去发布岗位</a>
                <%
                    }
                %>
            </div>
        <%
            } else {
                for (com.bupt.is.model.Job job : jobs) {
        %>
        <div class="card">
            <div class="tag"><%= job.isOpen() ? "OPEN" : job.getStatus() %></div>
            <h3><%= job.getTitle() %></h3>
            <div class="meta">课程/模块：<%= job.getModule() %></div>
            <div class="meta">最大人数：<%= job.getMaxApplicants() %></div>
            <div class="meta" style="margin-top:8px;">必需技能：</div>
            <ul>
                <%
                    if (job.getRequiredSkills() != null) {
                        for (String sk : job.getRequiredSkills()) {
                %>
                    <li><%= sk %></li>
                <%
                        }
                    }
                %>
            </ul>
            <a class="btn" href="<%=request.getContextPath()%>/jobs/detail?jobId=<%= job.getJobId() %>">查看详情</a>
        </div>
        <%
                }
            }
        %>
    </div>
</main>
</body>
</html>

