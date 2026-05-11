<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bupt.is.model.AdminApplicationRow" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Applications - Admin</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 1200px; margin: 24px auto; padding: 0 16px; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .summary { color: #4b5563; font-size: 14px; margin-bottom: 16px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th, td { border-bottom: 1px solid #e5e7eb; padding: 10px 8px; text-align: left; vertical-align: top; }
        th { background: #f9fafb; color: #374151; font-weight: 600; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; }
        .tag-accepted { background: #dcfce7; color: #166534; }
        .tag-rejected { background: #fee2e2; color: #991b1b; }
        .mono { font-family: ui-monospace, monospace; font-size: 12px; color: #6b7280; }
        .btn { border-radius: 999px; padding: 6px 12px; border: 1px solid #cbd5f5; background: #fff; color: #2563eb; font-size: 12px; text-decoration: none; display: inline-block; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>All job applications</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%= request.getContextPath() %>/jobs">Back to Admin home</a>
        <a href="<%= request.getContextPath() %>/auth/logout">Logout</a>
    </div>
</header>
<main>
    <div class="panel">
        <%
            Integer totalCount = (Integer) request.getAttribute("totalCount");
            int n = totalCount != null ? totalCount : 0;
        %>
        <p class="summary">Monitor every TA application across all jobs. Total: <strong><%= n %></strong></p>
        <%
            List<AdminApplicationRow> rows = (List<AdminApplicationRow>) request.getAttribute("rows");
        %>
        <% if (rows == null || rows.isEmpty()) { %>
            <p class="summary">No applications have been submitted yet.</p>
        <% } else { %>
            <div style="overflow-x:auto;">
                <table>
                    <thead>
                    <tr>
                        <th>Application</th>
                        <th>Job</th>
                        <th>Module</th>
                        <th>Applicant</th>
                        <th>Status</th>
                        <th>Applied</th>
                        <th>Score</th>
                        <th>CV</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (AdminApplicationRow row : rows) {
                        String st = row.getStatus() != null ? row.getStatus().toUpperCase() : "PENDING";
                        String tagClass = "tag";
                        if ("ACCEPTED".equals(st)) tagClass += " tag-accepted";
                        else if ("REJECTED".equals(st)) tagClass += " tag-rejected";
                    %>
                    <tr>
                        <td><span class="mono"><%= row.getApplicationId() %></span></td>
                        <td>
                            <div><%= row.getJobTitle() %></div>
                            <div class="mono" style="margin-top:4px;"><%= row.getJobId() %></div>
                        </td>
                        <td><%= row.getJobModule() %></td>
                        <td>
                            <div><%= row.getApplicantDisplayName() %></div>
                            <div class="mono" style="margin-top:4px;"><%= row.getApplicantId() %></div>
                        </td>
                        <td><span class="<%= tagClass %>"><%= st %></span></td>
                        <td><%= row.getAppliedAt() %></td>
                        <td><%= row.getScore() %></td>
                        <td>
                            <% if (row.getCvPath() != null && !row.getCvPath().trim().isEmpty()) { %>
                                <a class="btn" target="_blank" rel="noopener"
                                   href="<%= request.getContextPath() %>/files/cv?cvPath=<%= URLEncoder.encode(row.getCvPath().trim(), "UTF-8") %>">View</a>
                                <a class="btn" style="margin-top:6px;"
                                   href="<%= request.getContextPath() %>/files/cv?cvPath=<%= URLEncoder.encode(row.getCvPath().trim(), "UTF-8") %>&download=1">Download</a>
                            <% } else { %>
                                —
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</main>
</body>
</html>
