<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Admin Applications - TA Recruitment</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 18px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 1120px; margin: 24px auto; padding: 0 16px; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 26px 28px; }
        .panel h2 { margin: 0 0 8px; font-size: 24px; color: #111827; }
        .panel .muted { color: #6b7280; line-height: 1.6; }
        .nav-links { margin-top: 14px; display: flex; gap: 12px; flex-wrap: wrap; }
        .nav-links a { color: #2563eb; text-decoration: none; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; margin-top: 18px; }
        th, td { border: 1px solid #e5e7eb; padding: 12px 14px; text-align: left; vertical-align: top; font-size: 13px; }
        th { background: #f8fafc; color: #1f2937; font-weight: 600; }
        .tag { display: inline-flex; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; }
        .tag.accepted { background:#dcfce7; color:#166534; }
        .tag.rejected { background:#fee2e2; color:#991b1b; }
        .tag.pending { background:#e5e7eb; color:#374151; }
        .empty { color: #6b7280; font-size: 14px; margin-top: 18px; }
        .mono { font-family: monospace; }
    </style>
</head>
<body>
<%
    java.util.List<java.util.Map<String, String>> allApplications =
            (java.util.List<java.util.Map<String, String>>) request.getAttribute("allApplications");
%>
<header>
    <div>
        <strong>All Applications</strong>
        <span style="margin-left:12px;opacity:0.9;font-size:13px;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/admin/home">Home</a>
        <a href="<%=request.getContextPath()%>/admin/workload">Workload</a>
        <a href="<%=request.getContextPath()%>/admin/report">Report</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>
<main>
    <div class="panel">
        <h2>Job Applications</h2>
        <p class="muted">Monitor every TA application across all jobs.</p>
        <div class="nav-links">
            <a href="<%=request.getContextPath()%>/admin/home">Dashboard</a>
            <a href="<%=request.getContextPath()%>/admin/workload">Workload</a>
            <a href="<%=request.getContextPath()%>/admin/report">Report</a>
        </div>

        <% if (allApplications == null || allApplications.isEmpty()) { %>
            <div class="empty">No applications have been submitted yet.</div>
        <% } else { %>
            <table>
                <thead>
                <tr>
                    <th>Applicant</th>
                    <th>Job</th>
                    <th>Module</th>
                    <th>Status</th>
                    <th>Applied At</th>
                    <th>Rejection Reason</th>
                </tr>
                </thead>
                <tbody>
                <% for (java.util.Map<String, String> row : allApplications) {
                    String statusText = row.get("statusText");
                    String statusClass = "pending";
                    if ("admitted".equals(statusText)) {
                        statusClass = "accepted";
                    } else if ("rejected".equals(statusText)) {
                        statusClass = "rejected";
                    }
                %>
                    <tr>
                        <td><strong><%= row.get("applicantName") %></strong><br><span class="mono"><%= row.get("applicantId") %></span></td>
                        <td><%= row.get("jobTitle") %></td>
                        <td><%= row.get("module") %></td>
                        <td><span class="tag <%= statusClass %>"><%= statusText %></span></td>
                        <td><%= row.get("appliedAt") %></td>
                        <td><%= (row.get("rejectionReason") == null || row.get("rejectionReason").isEmpty()) ? "-" : row.get("rejectionReason") %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</main>
</body>
</html>
