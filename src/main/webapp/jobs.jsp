<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Jobs - TA Recruitment System</title>
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
        .ta-home {
            margin-top: 8px;
        }
        .ta-cards {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-top: 18px;
            width: 100%;
        }
        .ta-card {
            border: 1px solid #dbe4ff;
            border-radius: 14px;
            background: #f8fbff;
            padding: 30px 16px;
            text-align: center;
            text-decoration: none;
            color: #111827;
            box-shadow: 0 8px 16px rgba(37, 99, 235, 0.08);
        }
        .ta-card-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 8px;
            color: #1f2937;
        }
        .ta-card-sub {
            margin: 0;
            color: #4b5563;
            font-size: 14px;
            font-weight: 700;
        }
    </style>
</head>
<body>
<header>
    <div>
        <%
            String role = (String) request.getAttribute("role");
            String view = request.getParameter("view");
            boolean isAdminRole = "ADMIN".equalsIgnoreCase(role) || "ADMINISTRATOR".equalsIgnoreCase(role);
            boolean taSearchView = "TA".equals(role) && "search".equals(request.getParameter("view"));
            boolean moHomeView = "MO".equals(role) && (view == null || view.trim().isEmpty());
            boolean adminHomeView = isAdminRole && (view == null || view.trim().isEmpty());
            boolean moManageJobsView = "MO".equals(role) && "manage-jobs".equals(view);
            boolean moManageApplicantsView = "MO".equals(role) && "manage-applicants".equals(view);
        %>
        <% if (taSearchView) { %>
            <strong>Search Jobs</strong>
        <% } else if (moManageJobsView) { %>
            <strong>Manage Jobs</strong>
        <% } else if (moManageApplicantsView) { %>
            <strong>Manage Applicants</strong>
        <% } else if (adminHomeView) { %>
            <strong>Admin</strong>
        <% } %>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <% if ("TA".equals(role)) { %>
            <% if (taSearchView) { %>
                <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
            <% } %>
            <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
        <% } %>
        <% if ("MO".equals(role)) { %>
            <% if (!moHomeView) { %>
                <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
            <% } %>
            <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
        <% } %>
        <% if (!"TA".equals(role) && !"MO".equals(role)) { %>
            <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
        <% } %>
    </div>
</header>

<main>
    <div class="panel">
        <div class="messages">
            <%
                String applied = request.getParameter("applied");
                String posted = request.getParameter("posted");
                String updated = request.getParameter("updated");
                String closed = request.getParameter("closed");
                String error = (String) request.getAttribute("error");
                String keyword = (String) request.getAttribute("keyword");
                Boolean searchMode = (Boolean) request.getAttribute("searchMode");
            %>
            <% if (error != null) { %>
                <div class="error"><%= error %></div>
            <% } %>
            <% if ("1".equals(applied)) { %>
                <div class="success">Application submitted and recorded in My Applications.</div>
            <% } %>
            <% if ("1".equals(posted)) { %>
                <div class="success">Job posted successfully.</div>
            <% } %>
            <% if ("1".equals(updated)) { %>
                <div class="success">Job information updated.</div>
            <% } %>
            <% if ("1".equals(closed)) { %>
                <div class="success">Job posting closed successfully. No further applications are accepted.</div>
            <% } %>
        </div>

        <% if ("TA".equals(role) && !taSearchView) { %>
            <div class="ta-home">
                <h2 style="margin:0 0 6px;">Applicant</h2>
                <div class="summary">Select a function entry.</div>
                <div class="ta-cards">
                    <a class="ta-card" href="<%=request.getContextPath()%>/user/profile">
                        <p class="ta-card-title">Profile</p>
                        <p class="ta-card-sub">Create or modify profile</p>
                    </a>
                    <a class="ta-card" href="<%=request.getContextPath()%>/jobs?view=search">
                        <p class="ta-card-title">Search Jobs</p>
                        <p class="ta-card-sub">Find available jobs</p>
                    </a>
                    <a class="ta-card" href="<%=request.getContextPath()%>/applications">
                        <p class="ta-card-title">My Applications</p>
                        <p class="ta-card-sub">View application status</p>
                    </a>
                </div>
            </div>
        <% } else if (moHomeView) { %>
            <div class="ta-home">
                <h2 style="margin:0 0 6px;">MO</h2>
                <div class="summary">Select a function entry.</div>
                <div class="ta-cards">
                    <a class="ta-card" href="<%=request.getContextPath()%>/jobs/post">
                        <p class="ta-card-title">Post Job</p>
                        <p class="ta-card-sub">Post a new job</p>
                    </a>
                    <a class="ta-card" href="<%=request.getContextPath()%>/jobs?view=manage-jobs">
                        <p class="ta-card-title">Manage Jobs</p>
                        <p class="ta-card-sub">Manage posted jobs</p>
                    </a>
                    <a class="ta-card" href="<%=request.getContextPath()%>/jobs?view=manage-applicants">
                        <p class="ta-card-title">Manage Applicants</p>
                        <p class="ta-card-sub">Review applicants</p>
                    </a>
                </div>
            </div>
        <% } else if (adminHomeView) { %>
            <div class="ta-home">
                <h2 style="margin:0 0 6px;">Admin</h2>
                <div class="summary">Select a management entry.</div>
                <div class="ta-cards">
                    <a class="ta-card" href="javascript:void(0)">
                        <p class="ta-card-title">Workload Overview</p>
                    </a>
                    <a class="ta-card" href="javascript:void(0)">
                        <p class="ta-card-title">All Applications</p>
                    </a>
                    <a class="ta-card" href="javascript:void(0)">
                        <p class="ta-card-title">Workload Reports</p>
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="toolbar">
                <div>
                    <h2 style="margin:0 0 6px;">
                        <%= moManageJobsView ? "My Posted Jobs" : (moManageApplicantsView ? "Applicant-related Jobs" : "Available Jobs") %>
                    </h2>
                </div>
                <form class="search-box" action="<%=request.getContextPath()%>/jobs" method="get">
                    <% if ("TA".equals(role)) { %>
                        <input type="hidden" name="view" value="search">
                    <% } else if ("MO".equals(role) && view != null && !view.trim().isEmpty()) { %>
                        <input type="hidden" name="view" value="<%= view %>">
                    <% } %>
                    <input type="text" name="keyword" value="<%= keyword == null ? "" : keyword %>" placeholder="Search by module, title, or keyword">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <% if (searchMode != null && searchMode) { %>
                        <a class="btn" href="<%=request.getContextPath()%>/jobs<%= "TA".equals(role) ? "?view=search" : ("MO".equals(role) && view != null && !view.trim().isEmpty() ? "?view=" + view : "") %>">Clear</a>
                    <% } %>
                    <% if ("TA".equals(role)) { %>
                        <a class="btn" href="javascript:void(0)">Filter</a>
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
                            <%= (searchMode != null && searchMode) ? "No matching jobs found." : ("MO".equals(role) ? "No jobs available." : "No open jobs available.") %>
                        </div>
                        <% if ("MO".equals(role)) { %>
                            <a class="btn btn-primary" href="<%=request.getContextPath()%>/jobs/post">Post a Job</a>
                        <% } %>
                    </div>
                <%
                    } else {
                        for (com.bupt.is.model.Job job : jobs) {
                %>
                <div class="card">
                    <div class="tag"><%= job.isOpen() ? "ACTIVE" : job.getStatus() %></div>
                    <h3><%= job.getTitle() %></h3>
                    <div class="meta">Module: <%= job.getModule() %></div>
                    <div class="meta">Max Applicants: <%= job.getMaxApplicants() %></div>
                    <div class="meta" style="margin-top:8px;">Required Skills:</div>
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
                    <% if ("MO".equals(role) && moManageApplicantsView) { %>
                        <a class="btn" href="<%=request.getContextPath()%>/jobs/applicants?jobId=<%= job.getJobId() %>">Manage Applicants</a>
                    <% } else { %>
                        <a class="btn" href="<%=request.getContextPath()%>/jobs/detail?jobId=<%= job.getJobId() %>">View Detail</a>
                    <% } %>
                    <% if ("MO".equals(role) && moManageJobsView && job.isOpen()) { %>
                        <form action="<%=request.getContextPath()%>/jobs/close" method="post" style="margin-top:10px;" onsubmit="return confirm('Close this job posting? After closing, no further applications will be accepted.');">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <button type="submit" class="btn" style="background:#dc2626;color:#fff;border:none;">Close Job Posting</button>
                        </form>
                    <% } %>
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
