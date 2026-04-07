<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>岗位列表 - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 1120px; margin: 24px auto; padding: 0 16px; }
        .panel { background:#fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .messages { margin-bottom: 16px; }
        .success { background: #dcfce7; color: #166534; padding: 10px 12px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px 12px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .toolbar { display:flex; justify-content:space-between; gap:16px; align-items:end; flex-wrap:wrap; margin-bottom: 18px; }
        .search-box { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
        input[type="text"] { min-width: 320px; padding: 10px 12px; border:1px solid #d1d5db; border-radius: 10px; font-size: 14px; }
        .btn { border-radius: 999px; padding: 9px 16px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 14px; text-decoration:none; display:inline-block; cursor:pointer; }
        .btn-primary { border:none; background:#2563eb; color:#fff; }
        .summary { color:#4b5563; font-size:13px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; }
        .card { border: 1px solid #e1e5f2; border-radius: 12px; padding: 16px; background: #fafbff; }
        .card h3 { margin: 10px 0 8px; font-size: 18px; color: #111827; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; margin-right: 6px; }
        ul { margin: 6px 0 0 18px; padding: 0; }
        li { color:#4b5563; font-size: 13px; margin-bottom: 4px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>岗位列表</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div>
        <%
            String role = (String) request.getAttribute("role");
        %>
        <% if ("TA".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/applications">我的申请</a>
            <a href="<%=request.getContextPath()%>/user/profile">我的档案/CV</a>
        <% } %>
        <% if ("MO".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/jobs/post">发布岗位</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <div class="panel">
        <div class="messages">
            <%
                String applied = request.getParameter("applied");
                String posted = request.getParameter("posted");
                String updated = request.getParameter("updated");
                String error = (String) request.getAttribute("error");
                String keyword = (String) request.getAttribute("keyword");
                Boolean searchMode = (Boolean) request.getAttribute("searchMode");
            %>
            <% if (error != null) { %>
                <div class="error"><%= error %></div>
            <% } %>
            <% if ("1".equals(applied)) { %>
                <div class="success">申请已提交，已记录到我的申请列表中。</div>
            <% } %>
            <% if ("1".equals(posted)) { %>
                <div class="success">岗位已发布。</div>
            <% } %>
            <% if ("1".equals(updated)) { %>
                <div class="success">岗位信息已更新。</div>
            <% } %>
        </div>

        <div class="toolbar">
            <div>
                <h2 style="margin:0 0 6px;">可申请岗位</h2>
                <div class="summary">Story 6：展示开放岗位列表。Story 7：支持按课程模块或关键词搜索。</div>
            </div>
            <form class="search-box" action="<%=request.getContextPath()%>/jobs" method="get">
                <input type="text" name="keyword" value="<%= keyword == null ? "" : keyword %>" placeholder="输入课程模块、岗位标题或关键词搜索">
                <button type="submit" class="btn btn-primary">搜索</button>
                <% if (searchMode != null && searchMode) { %>
                    <a class="btn" href="<%=request.getContextPath()%>/jobs">清空</a>
                <% } %>
            </form>
        </div>

        <div class="grid">
            <%
                java.util.List<com.bupt.is.model.Job> jobs = (java.util.List<com.bupt.is.model.Job>) request.getAttribute("jobs");
                if (jobs == null || jobs.isEmpty()) {
            %>
                <div class="card" style="grid-column: 1 / -1;">
                    <div class="meta">
                        <%= (searchMode != null && searchMode) ? "没有找到匹配的岗位。" : "暂无开放岗位。" %>
                    </div>
                    <% if ("MO".equals(role)) { %>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/jobs/post">去发布岗位</a>
                    <% } %>
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
    </div>
</main>
</body>
</html>
