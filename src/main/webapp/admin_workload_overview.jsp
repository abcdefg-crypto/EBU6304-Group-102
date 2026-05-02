<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bupt.is.model.Job" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Workload Overview - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 1280px; margin: 24px auto; padding: 0 16px; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .toolbar { display: flex; justify-content: space-between; gap: 16px; align-items: flex-end; flex-wrap: wrap; margin-bottom: 18px; }
        .search-box { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        input[type="text"] { min-width: 260px; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; }
        .btn { border-radius: 999px; padding: 9px 16px; border: 1px solid #cbd5f5; background: #fff; color: #2563eb; font-size: 14px; text-decoration: none; display: inline-block; cursor: pointer; }
        .btn-primary { border: none; background: #2563eb; color: #fff; }
        .summary { color: #4b5563; font-size: 13px; margin: 0 0 6px; }
        .table-wrap { overflow-x: auto; border: 1px solid #e5e7eb; border-radius: 10px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th, td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #f3f4f6; vertical-align: top; }
        th { background: #f9fafb; color: #374151; font-weight: 600; white-space: nowrap; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafbff; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; }
        .skills { color: #4b5563; max-width: 220px; word-break: break-word; }
        .desc { color: #6b7280; max-width: 280px; word-break: break-word; }
        .empty { padding: 24px; text-align: center; color: #6b7280; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>Workload Overview</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%= request.getContextPath() %>/jobs">Back to Admin Home</a>
        <a href="<%= request.getContextPath() %>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <%
        String kw = (String) request.getAttribute("keyword");
        Boolean sm = (Boolean) request.getAttribute("searchMode");
        List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    %>
    <div class="panel">
        <div class="toolbar">
            <div>
                <h2 style="margin:0 0 6px;">All job positions</h2>
                <p class="summary">System-wide list (open and closed). Use search to filter by module, title, or keyword.</p>
            </div>
            <form class="search-box" action="<%= request.getContextPath() %>/jobs" method="get">
                <input type="hidden" name="view" value="workload-overview">
                <input type="text" name="keyword" value="<%= kw == null ? "" : kw %>" placeholder="Module, title, keyword…">
                <button type="submit" class="btn btn-primary">Search</button>
                <% if (sm != null && sm) { %>
                    <a class="btn" href="<%= request.getContextPath() %>/jobs?view=workload-overview">Clear</a>
                <% } %>
            </form>
        </div>

        <%
            if (jobs == null || jobs.isEmpty()) {
        %>
            <div class="empty">
                <%= (sm != null && sm) ? "No jobs match your search." : "No job postings in the system yet." %>
            </div>
        <%
            } else {
        %>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Job ID</th>
                        <th>Title</th>
                        <th>Module</th>
                        <th>Status</th>
                        <th>Max applicants</th>
                        <th>Posted by (MO user ID)</th>
                        <th>Required skills</th>
                        <th>Description</th>
                        <th></th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Job job : jobs) {
                            String skillsText = "";
                            if (job.getRequiredSkills() != null && !job.getRequiredSkills().isEmpty()) {
                                skillsText = String.join(", ", job.getRequiredSkills());
                            } else {
                                skillsText = "—";
                            }
                            String desc = job.getDescription();
                            if (desc == null) desc = "";
                            if (desc.length() > 160) {
                                desc = desc.substring(0, 160) + "…";
                            }
                            if (desc.isEmpty()) desc = "—";
                            String statusLabel = job.isOpen() ? "OPEN" : (job.getStatus() != null ? job.getStatus() : "—");
                    %>
                    <tr>
                        <td><%= job.getJobId() %></td>
                        <td><%= job.getTitle() == null ? "—" : job.getTitle() %></td>
                        <td><%= job.getModule() == null ? "—" : job.getModule() %></td>
                        <td><span class="tag"><%= statusLabel %></span></td>
                        <td><%= job.getMaxApplicants() %></td>
                        <td><%= job.getPostedBy() == null ? "—" : job.getPostedBy() %></td>
                        <td class="skills"><%= skillsText %></td>
                        <td class="desc"><%= desc %></td>
                        <td>
                            <a class="btn" href="<%= request.getContextPath() %>/jobs/detail?jobId=<%= job.getJobId() %>">Detail</a>
                        </td>
                        <td>
                            <a class="btn" href="<%= request.getContextPath() %>/jobs/applicants?jobId=<%= job.getJobId() %>">Applicants</a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        <%
            }
        %>
    </div>
</main>
</body>
</html>
