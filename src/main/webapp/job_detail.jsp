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
        .grid { display: grid; grid-template-columns: 1fr; gap: 16px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .btn { border-radius: 999px; padding: 9px 16px; border: none; font-size: 14px; cursor: pointer; text-decoration:none; display:inline-block; background:#2563eb; color:#fff; }
        .btn-small { padding: 6px 10px; font-size: 12px; }
        .btn-accept { background:#16a34a; }
        .btn-reject { background:#dc2626; }
        .btn-pending { background:#6b7280; }
        ul { margin: 6px 0 0 18px; padding: 0; }
        li { color:#4b5563; font-size: 13px; margin-bottom: 4px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>岗位详情</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div>
        <%
            String role = (String) request.getAttribute("role");
        %>
        <a href="<%=request.getContextPath()%>/jobs">返回岗位列表</a>
        <% if ("TA".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/applications">我的申请</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <%
        String error = (String) request.getAttribute("error");
        com.bupt.is.model.Job job = (com.bupt.is.model.Job) request.getAttribute("job");
        boolean canApply = request.getAttribute("canApply") != null && (boolean) request.getAttribute("canApply");
        boolean hasApplied = request.getAttribute("hasApplied") != null && (boolean) request.getAttribute("hasApplied");
        boolean canEditJob = request.getAttribute("canEditJob") != null && (boolean) request.getAttribute("canEditJob");
        String statusUpdated = request.getParameter("statusUpdated");
        String statusError = request.getParameter("statusError");
    %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>
    <% if ("1".equals(statusUpdated)) { %>
        <div style="background:#dcfce7;color:#166534;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
            申请状态已更新。
        </div>
    <% } %>
    <% if ("1".equals(statusError)) { %>
        <div class="error">状态更新失败，请重试。</div>
    <% } %>

    <div class="grid">
        <div class="card">
            <div class="tag"><%= job != null ? job.getStatus() : "" %></div>
            <h2 style="font-size:18px;margin-top:10px;"><%= job != null ? job.getTitle() : "" %></h2>
            <div class="meta">岗位 ID：<%= job != null ? job.getJobId() : "" %></div>
            <div class="meta">课程/模块：<%= job != null ? job.getModule() : "" %></div>
            <div class="meta">最大人数：<%= job != null ? job.getMaxApplicants() : "" %></div>

            <div class="meta" style="margin-top:12px;"><strong>岗位描述</strong></div>
            <div class="meta" style="white-space:pre-wrap;"><%= job != null ? job.getDescription() : "" %></div>

            <div class="meta" style="margin-top:12px;"><strong>要求与技能</strong></div>
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

            <div class="meta" style="margin-top:12px;"><strong>职责说明</strong></div>
            <div class="meta">请结合岗位描述与技能要求理解该岗位的 responsibilities。</div>

            <% if (canEditJob && job != null) { %>
                <div style="margin-top:16px;">
                    <a class="btn" style="background:#7c3aed;" href="<%=request.getContextPath()%>/jobs/post?jobId=<%= job.getJobId() %>">编辑岗位</a>
                </div>
            <% } %>

            <% if ("TA".equals(role)) { %>
                <div style="margin-top:16px;">
                    <% if (hasApplied) { %>
                        <a class="btn" style="background:#16a34a;" href="<%=request.getContextPath()%>/applications">已申请（查看状态）</a>
                    <% } else if (canApply) { %>
                        <form action="<%=request.getContextPath()%>/applications/apply" method="post">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <button type="submit" class="btn">申请该岗位</button>
                        </form>
                    <% } else { %>
                        <div class="meta">当前岗位不可申请。</div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <% if ("MO".equals(role)) { %>
            <div class="card">
                <h2 style="font-size:16px;margin-top:0;">申请者与简历</h2>
                <div class="meta">MO 可以查看申请此岗位的候选人及其 PDF 简历。</div>
                <%
                    java.util.List<com.bupt.is.model.Application> applications =
                            (java.util.List<com.bupt.is.model.Application>) request.getAttribute("applications");
                    java.util.Map<String, String> applicantNameMap =
                            (java.util.Map<String, String>) request.getAttribute("applicantNameMap");
                    if (applications == null || applications.isEmpty()) {
                %>
                    <div class="meta" style="margin-top:10px;">暂无申请者。</div>
                <%
                    } else {
                        for (com.bupt.is.model.Application a : applications) {
                            String applicantName = applicantNameMap == null ? a.getApplicantId() : applicantNameMap.get(a.getApplicantId());
                            if (applicantName == null || applicantName.trim().isEmpty()) {
                                applicantName = a.getApplicantId();
                            }
                %>
                    <div class="meta" style="margin-top:12px;">
                        <strong>申请者：</strong><%= applicantName %>（<%= a.getApplicantId() %>）
                    </div>
                    <div class="meta"><strong>当前状态：</strong><%= a.getStatus() %></div>
                    <% if (a.getCvPath() == null || a.getCvPath().trim().isEmpty()) { %>
                        <div class="meta">简历：未上传</div>
                    <% } else { %>
                        <a class="btn" style="background:#0ea5e9;" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=a.getCvPath()%>">查看/下载简历 PDF</a>
                    <% } %>
                    <div style="margin-top:8px;">
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="ACCEPTED">
                            <button type="submit" class="btn btn-small btn-accept">录用</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="REJECTED">
                            <button type="submit" class="btn btn-small btn-reject">拒绝</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="PENDING">
                            <button type="submit" class="btn btn-small btn-pending">设为待定</button>
                        </form>
                    </div>
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
