<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Post Job - TA Recruitment System</title>
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
        <strong>Post Job</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
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
        <h2 style="font-size:16px;margin-top:0;"><%= editing ? "Edit Job" : "MO Job Posting" %></h2>
        <p style="color:#6b7280;font-size:13px;margin-top:0;">Required: title, description, module, required skills/qualifications, max applicants.</p>

        <form action="<%= request.getContextPath() %>/jobs/post" method="post">
            <% if (editing) { %>
                <input type="hidden" name="jobId" value="<%= editJob.getJobId() %>">
            <% } %>
            <div class="field">
                <label>Job Title</label>
                <input type="text" name="title" required value="<%= titleVal %>">
            </div>
            <div class="field">
                <label>Module</label>
                <input type="text" name="module" required value="<%= moduleVal %>">
            </div>
            <div class="field">
                <label>Required Skills / Qualifications (comma, semicolon, or newline separated)</label>
                <input type="text" name="requiredSkills" placeholder="e.g. Java, Data Structures, TA experience" required value="<%= skillsVal %>">
            </div>
            <div class="field">
                <label>Max Applicants</label>
                <input type="text" name="maxApplicants" required value="<%= maxVal %>">
            </div>
            <div class="field">
                <label>Job Description</label>
                <textarea name="description" required><%= descVal %></textarea>
            </div>

            <button type="submit" class="btn-primary"><%= editing ? "Save Changes" : "Post Job" %></button>
            <a href="<%=request.getContextPath()%>/jobs?view=manage-jobs" class="btn-outline">Cancel</a>
        </form>
    </div>

    <div style="margin-top:14px;color:#6b7280;font-size:13px;">
        Tip: TA users can see OPEN jobs in the list and apply from the detail page.
    </div>
</main>
</body>
</html>

