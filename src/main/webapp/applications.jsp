<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的申请 - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; margin-bottom: 14px; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; margin-right: 6px; }
        .tag.accepted { background:#dcfce7; color:#166534; }
        .tag.rejected { background:#fee2e2; color:#991b1b; }
        .tag.pending { background:#e5e7eb; color:#374151; }
        .empty { color:#6b7280; font-size:14px; }
        .btn { border-radius: 999px; padding: 8px 14px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 13px; text-decoration:none; display:inline-block; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>我的申请</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">岗位列表</a>
        <a href="<%=request.getContextPath()%>/user/profile">我的档案/CV</a>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <h2 style="margin-top:0;">已提交申请</h2>
    <p class="meta">Story 8：提交申请后，申请会出现在用户自己的 application list 中。</p>

    <%
        String submitted = request.getParameter("submitted");
        String submittedJobTitle = request.getParameter("jobTitle");
        String submittedAppliedAt = request.getParameter("appliedAt");
    %>
    <% if ("1".equals(submitted)) { %>
        <div style="background:#dcfce7;color:#166534;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
            申请提交成功：岗位「<%= submittedJobTitle == null ? "-" : submittedJobTitle %>」，申请日期 <%= submittedAppliedAt == null ? "-" : submittedAppliedAt %>。
        </div>
    <% } %>

    <%
        java.util.List<com.bupt.is.model.ApplicationView> applications =
                (java.util.List<com.bupt.is.model.ApplicationView>) request.getAttribute("applications");
        if (applications == null || applications.isEmpty()) {
    %>
        <div class="empty">你还没有提交任何申请。先去岗位列表看看吧。</div>
    <%
        } else {
            for (com.bupt.is.model.ApplicationView appView : applications) {
                String status = appView.getStatus() == null ? "PENDING" : appView.getStatus().trim().toUpperCase();
                String tagClass = "pending";
                String statusText = "pending";
                if ("ACCEPTED".equals(status)) {
                    tagClass = "accepted";
                    statusText = "accepted";
                } else if ("REJECTED".equals(status)) {
                    tagClass = "rejected";
                    statusText = "rejected";
                }
    %>
        <div class="card">
            <div class="tag <%= tagClass %>"><%= statusText %></div>
            <h3 style="margin:10px 0 8px;"><%= appView.getJobTitle() %></h3>
            <div class="meta">课程/模块：<%= appView.getModule() %></div>
            <div class="meta">申请编号：<%= appView.getApplicationId() %></div>
            <div class="meta">岗位编号：<%= appView.getJobId() %></div>
            <div class="meta">申请日期：<%= appView.getAppliedAt() == null ? "-" : appView.getAppliedAt() %></div>
            <a class="btn" href="<%=request.getContextPath()%>/jobs/detail?jobId=<%= appView.getJobId() %>">查看岗位详情</a>
        </div>
    <%
            }
        }
    %>
</main>
</body>
</html>
