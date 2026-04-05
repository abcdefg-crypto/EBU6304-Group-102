<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>岗位详情 - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        h2 { margin: 0 0 12px; font-size: 16px; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; margin-right: 6px; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 14px; }
        .success { background: #dcfce7; color: #166534; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 14px; }
        .grid { display: grid; grid-template-columns: 1fr; gap: 16px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .btn { border-radius: 999px; padding: 9px 16px; border: none; font-size: 14px; cursor: pointer; text-decoration:none; display:inline-block; background:#2563eb; color:#fff; }
        ul { margin: 6px 0 0 18px; padding: 0; }
        li { color:#4b5563; font-size: 13px; margin-bottom: 4px; }
        textarea { width: 100%; min-height: 80px; border-radius: 9px; border: 1px solid #d1d5db; padding: 9px 11px; font-size: 13px; box-sizing: border-box; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>岗位详情</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">返回岗位列表</a>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <%
        String error = (String) request.getAttribute("error");
        com.bupt.is.model.Job job = (com.bupt.is.model.Job) request.getAttribute("job");
        boolean canApply = request.getAttribute("canApply") != null && (boolean) request.getAttribute("canApply");
        boolean canEditJob = request.getAttribute("canEditJob") != null && (boolean) request.getAttribute("canEditJob");
        String role = (String) request.getAttribute("role");
    %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <div class="grid">
        <div class="card">
            <div class="tag"><%= job != null ? job.getStatus() : "" %></div>
            <h2 style="font-size:18px;margin-top:0;"><%= job != null ? job.getTitle() : "" %></h2>
            <div class="meta">岗位ID：<%= job != null ? job.getJobId() : "" %></div>
            <div class="meta">课程/模块：<%= job != null ? job.getModule() : "" %></div>
            <div class="meta">最大人数：<%= job != null ? job.getMaxApplicants() : "" %></div>

            <div class="meta" style="margin-top:10px;">岗位描述：</div>
            <div class="meta" style="white-space:pre-wrap;"><%= job != null ? job.getDescription() : "" %></div>

            <div class="meta" style="margin-top:10px;">必需技能（Story12）：</div>
            <ul>
                <%
                    if (job != null && job.getRequiredSkills() != null) {
                        for (String sk : job.getRequiredSkills()) {
                %>
                <li><%= sk %></li>
                <%
                        }
                    }
                %>
            </ul>

            <% if (canEditJob && job != null) { %>
                <div style="margin-top:16px;">
                    <a class="btn" style="background:#7c3aed;" href="<%=request.getContextPath()%>/jobs/post?jobId=<%= job.getJobId() %>">编辑岗位</a>
                </div>
            <% } %>

            <% if ("TA".equals(role)) { %>
                <div style="margin-top:16px;">
                    <%
                        if (canApply) {
                    %>
                    <form action="applications/apply" method="post">
                        <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                        <button type="submit" class="btn">申请该岗位（Story8）</button>
                    </form>
                    <%
                        } else {
                    %>
                    <div class="meta">当前岗位不可申请。</div>
                    <%
                        }
                    %>
                </div>
            <% } %>
        </div>

        <% if ("MO".equals(role)) { %>
            <div class="card">
                <h2 style="font-size:16px;margin-top:0;">申请者简历（用于演示 Story5）</h2>
                <div class="meta">演示：MO 可以在已发布岗位下看到 TA 的申请与简历文件。</div>

                <%
                    java.util.List<com.bupt.is.model.ApplicantCV> applicantCvs =
                        (java.util.List<com.bupt.is.model.ApplicantCV>) request.getAttribute("applicantCvs");
                    if (applicantCvs == null || applicantCvs.isEmpty()) {
                %>
                    <div class="meta" style="margin-top:10px;">暂无申请者。</div>
                <%
                    } else {
                        for (com.bupt.is.model.ApplicantCV a : applicantCvs) {
                %>
                    <div class="meta" style="margin-top:12px;">
                        <strong>申请者：</strong><%= a.getApplicantUsername() %>（<%= a.getApplicantId() %>）
                    </div>
                    <%
                        if (a.getCvPath() == null || a.getCvPath().trim().isEmpty()) {
                    %>
                        <div class="meta">简历：未上传</div>
                    <%
                        } else {
                    %>
                        <a class="btn" style="background:#0ea5e9;border:none;cursor:pointer;" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=a.getCvPath()%>">查看/下载简历 PDF</a>
                    <%
                        }
                    %>
                <%
                        }
                    }
                %>
            </div>
        <% } %>
    </div>
</main>
</body>
</html>

