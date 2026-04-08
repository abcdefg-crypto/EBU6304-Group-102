<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Job Detail - TA Recruitment System</title>
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
        <strong>Job Detail</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <%
            String role = (String) request.getAttribute("role");
            String fromParam = request.getParameter("from");
            String referer = request.getHeader("Referer");
            boolean fromApplications = "applications".equals(fromParam)
                    || (referer != null && referer.contains("/applications"));
        %>
        <% if ("TA".equals(role)) { %>
            <% if (fromApplications) { %>
                <a href="<%=request.getContextPath()%>/applications">Back to Application List</a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/jobs?view=search">Back to Job List</a>
            <% } %>
            <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <% } else { %>
            <a href="<%=request.getContextPath()%>/jobs">Back to Job List</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
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
            Application status updated.
        </div>
    <% } %>
    <% if ("1".equals(statusError)) { %>
        <div class="error">Status update failed. Please try again.</div>
    <% } %>

    <div class="grid">
        <div class="card">
            <div class="tag"><%= job != null ? job.getStatus() : "" %></div>
            <h2 style="font-size:18px;margin-top:10px;"><%= job != null ? job.getTitle() : "" %></h2>
            <div class="meta">Job ID: <%= job != null ? job.getJobId() : "" %></div>
            <div class="meta">Module: <%= job != null ? job.getModule() : "" %></div>
            <div class="meta">Max Applicants: <%= job != null ? job.getMaxApplicants() : "" %></div>

            <div class="meta" style="margin-top:12px;"><strong>Job Description</strong></div>
            <div class="meta" style="white-space:pre-wrap;"><%= job != null ? job.getDescription() : "" %></div>

            <div class="meta" style="margin-top:12px;"><strong>Requirements & Skills</strong></div>
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

            <div class="meta" style="margin-top:12px;"><strong>Responsibilities</strong></div>
            <div class="meta">Please review responsibilities based on job description and required skills.</div>

            <% if (canEditJob && job != null) { %>
                <div style="margin-top:16px;">
                    <a class="btn" style="background:#7c3aed;" href="<%=request.getContextPath()%>/jobs/post?jobId=<%= job.getJobId() %>">Edit Job</a>
                </div>
            <% } %>

            <% if ("TA".equals(role)) { %>
                <div style="margin-top:16px;">
                    <% if (hasApplied) { %>
                        <% if (!fromApplications) { %>
                            <a class="btn" style="background:#16a34a;" href="<%=request.getContextPath()%>/applications">Applied (View Status)</a>
                        <% } %>
                    <% } else if (canApply) { %>
                        <form action="<%=request.getContextPath()%>/applications/apply" method="post">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <button type="submit" class="btn">Apply for this Job</button>
                        </form>
                    <% } else { %>
                        <div class="meta">This job is currently not open for application.</div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <% if ("MO".equals(role)) { %>
            <div class="card">
                <h2 style="font-size:16px;margin-top:0;">Applicants & CVs</h2>
                <div class="meta">MO can view applicants and their PDF CVs for this job.</div>
                <%
                    java.util.List<com.bupt.is.model.Application> applications =
                            (java.util.List<com.bupt.is.model.Application>) request.getAttribute("applications");
                    java.util.Map<String, String> applicantNameMap =
                            (java.util.Map<String, String>) request.getAttribute("applicantNameMap");
                    if (applications == null || applications.isEmpty()) {
                %>
                    <div class="meta" style="margin-top:10px;">No applicants yet.</div>
                <%
                    } else {
                        for (com.bupt.is.model.Application a : applications) {
                            String applicantName = applicantNameMap == null ? a.getApplicantId() : applicantNameMap.get(a.getApplicantId());
                            if (applicantName == null || applicantName.trim().isEmpty()) {
                                applicantName = a.getApplicantId();
                            }
                %>
                    <div class="meta" style="margin-top:12px;">
                        <strong>Applicant:</strong> <%= applicantName %> (<%= a.getApplicantId() %>)
                    </div>
                    <div class="meta"><strong>Status:</strong> <%= a.getStatus() %></div>
                    <% if (a.getCvPath() == null || a.getCvPath().trim().isEmpty()) { %>
                        <div class="meta">CV: Not uploaded</div>
                    <% } else { %>
                        <a class="btn" style="background:#0ea5e9;" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=a.getCvPath()%>">View/Download CV PDF</a>
                    <% } %>
                    <div style="margin-top:8px;">
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="ACCEPTED">
                            <button type="submit" class="btn btn-small btn-accept">Accept</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="REJECTED">
                            <button type="submit" class="btn btn-small btn-reject">Reject</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                            <input type="hidden" name="status" value="PENDING">
                            <button type="submit" class="btn btn-small btn-pending">Set Pending</button>
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
