<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>All Applications - TA Recruitment System</title>
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
        .status-tag { display: inline-block; padding: 3px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; }
        .status-pending { background: #e5e7eb; color: #374151; }
        .status-accepted { background: #dcfce7; color: #166534; }
        .status-rejected { background: #fee2e2; color: #991b1b; }
        .empty { padding: 24px; text-align: center; color: #6b7280; }
        .muted { color: #6b7280; max-width: 200px; word-break: break-word; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>All Applications</strong>
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
        List<Map<String, String>> applicationRows = (List<Map<String, String>>) request.getAttribute("applicationRows");
    %>
    <div class="panel">
        <div class="toolbar">
            <div>
                <h2 style="margin:0 0 6px;">All applicants</h2>
                <p class="summary">Every application in the system. Search by application ID, job, module, applicant name, student ID, or status.</p>
            </div>
            <form class="search-box" action="<%= request.getContextPath() %>/jobs" method="get">
                <input type="hidden" name="view" value="all-applications">
                <input type="text" name="keyword" value="<%= kw == null ? "" : kw %>" placeholder="Keyword…">
                <button type="submit" class="btn btn-primary">Search</button>
                <% if (sm != null && sm) { %>
                    <a class="btn" href="<%= request.getContextPath() %>/jobs?view=all-applications">Clear</a>
                <% } %>
            </form>
        </div>

        <%
            if (applicationRows == null || applicationRows.isEmpty()) {
        %>
            <div class="empty">
                <%= (sm != null && sm) ? "No applications match your search." : "No applications submitted yet." %>
            </div>
        <%
            } else {
        %>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Job ID</th>
                        <th>Job title</th>
                        <th>Module</th>
                        <th>Applicant name</th>
                        <th>Student ID</th>
                        <th>Applicant user ID</th>
                        <th>Status</th>
                        <th>Applied at</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Map<String, String> row : applicationRows) {
                            String s0 = row.get("status") == null ? "PENDING" : row.get("status").trim().toUpperCase();
                            String statusClass = "status-pending";
                            if ("ACCEPTED".equals(s0)) statusClass = "status-accepted";
                            else if ("REJECTED".equals(s0)) statusClass = "status-rejected";
                    %>
                    <tr>
                        <td><%= row.get("applicationId") %></td>
                        <td><%= row.get("jobId") %></td>
                        <td><%= row.get("jobTitle") %></td>
                        <td><%= row.get("module") %></td>
                        <td><%= row.get("applicantName") %></td>
                        <td><%= row.get("studentId") %></td>
                        <td class="muted"><%= row.get("applicantId") %></td>
                        <td><span class="status-tag <%= statusClass %>"><%= s0 %></span></td>
                        <td><%= row.get("appliedAt") %></td>
                        <td>
                            <a class="btn" href="<%= request.getContextPath() %>/jobs/applicant-detail?jobId=<%= row.get("jobId") %>&applicantId=<%= row.get("applicantId") %>">Detail</a>
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
