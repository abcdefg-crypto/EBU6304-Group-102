<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>发布岗位 - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 900px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        h2 { margin: 0 0 12px; font-size: 16px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        .field { margin-bottom: 14px; }
        label { display: block; font-size: 13px; color: #374151; margin-bottom: 6px; }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            box-sizing: border-box;
        }
        textarea { min-height: 110px; resize: vertical; }
        .btn-primary { background: #2563eb; border:none; color:#fff; border-radius:999px; padding: 9px 16px; font-size: 14px; cursor: pointer; }
        .btn-outline { background: #fff; border:1px solid #cbd5f5; color:#2563eb; border-radius:999px; padding: 9px 16px; font-size: 14px; cursor: pointer; display:inline-block; text-decoration:none; }
        .error { background:#fee2e2; color:#991b1b; padding:10px; border-radius:10px; font-size:13px; margin-bottom:14px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>发布岗位</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">岗位列表</a>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <%
        String error = (String) request.getAttribute("error");
        com.bupt.is.model.Job editJob = (com.bupt.is.model.Job) request.getAttribute("editJob");
        boolean editing = editJob != null;

        String pTitle = request.getParameter("title");
        String titleVal = pTitle != null ? pTitle : (editing && editJob.getTitle() != null ? editJob.getTitle() : "");
        String pModule = request.getParameter("module");
        String moduleVal = pModule != null ? pModule : (editing && editJob.getModule() != null ? editJob.getModule() : "");
        String pDesc = request.getParameter("description");
        String descVal = pDesc != null ? pDesc : (editing && editJob.getDescription() != null ? editJob.getDescription() : "");
        String pSkills = request.getParameter("requiredSkills");
        String skillsVal = pSkills != null ? pSkills : "";
        if (skillsVal.isEmpty() && editing && editJob.getRequiredSkills() != null) {
            skillsVal = String.join(", ", editJob.getRequiredSkills());
        }
        String pMax = request.getParameter("maxApplicants");
        String maxVal = pMax != null ? pMax : (editing ? String.valueOf(editJob.getMaxApplicants()) : "10");
    %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <div class="card">
        <h2 style="font-size:16px;margin-top:0;"><%= editing ? "编辑岗位" : "MO 岗位发布（Story13）" %></h2>
        <p style="color:#6b7280;font-size:13px;margin-top:0;">必填：标题、描述、课程/模块、技能与资格要求、最大人数。</p>

        <form action="<%= request.getContextPath() %>/jobs/post" method="post">
            <% if (editing) { %>
                <input type="hidden" name="jobId" value="<%= editJob.getJobId() %>">
            <% } %>
            <div class="field">
                <label>岗位标题</label>
                <input type="text" name="title" required value="<%= titleVal %>">
            </div>
            <div class="field">
                <label>课程/模块</label>
                <input type="text" name="module" required value="<%= moduleVal %>">
            </div>
            <div class="field">
                <label>必需技能 / 资格要求（逗号、分号或换行分隔）</label>
                <input type="text" name="requiredSkills" placeholder="例如：Java, 数据结构, 有相关助教经验" required value="<%= skillsVal %>">
            </div>
            <div class="field">
                <label>最大申请人数</label>
                <input type="text" name="maxApplicants" required value="<%= maxVal %>">
            </div>
            <div class="field">
                <label>岗位描述</label>
                <textarea name="description" required><%= descVal %></textarea>
            </div>

            <button type="submit" class="btn-primary"><%= editing ? "保存修改" : "发布岗位" %></button>
            <a href="<%=request.getContextPath()%>/jobs" class="btn-outline">返回岗位列表</a>
        </form>
    </div>

    <div style="margin-top:14px;color:#6b7280;font-size:13px;">
        提示：TA 登录后会在岗位列表中看到 OPEN 岗位，并可在详情页申请。
    </div>
</main>
</body>
</html>

