<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Admin Report - TA Recruitment</title>
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
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-top: 24px; }
        .summary-card { border: 1px solid #e5e7eb; border-radius: 12px; padding: 18px; background: #f8fafc; }
        .summary-card .label { font-size: 12px; color: #6b7280; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px; }
        .summary-card .value { font-size: 28px; font-weight: 700; color: #111827; }
        table { width: 100%; border-collapse: collapse; margin-top: 22px; }
        th, td { border: 1px solid #e5e7eb; padding: 12px 14px; text-align: left; vertical-align: top; font-size: 13px; }
        th { background: #f8fafc; color: #1f2937; font-weight: 600; }
        .empty { color: #6b7280; font-size: 14px; margin-top: 18px; }
        .mono { font-family: monospace; }
    </style>
</head>
<body>
<%
    java.util.List<java.util.Map<String, Object>> reportRows =
            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("reportRows");
%>
<header>
    <div>
        <strong>Workload Report</strong>
        <span style="margin-left:12px;opacity:0.9;font-size:13px;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/admin/home">Home</a>
        <a href="<%=request.getContextPath()%>/admin/applications">Applications</a>
        <a href="<%=request.getContextPath()%>/admin/workload">Workload</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>
<main>
    <div class="panel">
        <h2>TA Workload Summary Report</h2>
        <p class="muted">This report shows TA workload totals and assigned modules clearly for each TA.</p>
        <div class="nav-links">
            <a href="<%=request.getContextPath()%>/admin/home">Dashboard</a>
            <a href="<%=request.getContextPath()%>/admin/applications">Applications</a>
            <a href="<%=request.getContextPath()%>/admin/workload">Workload</a>
        </div>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="label">Total TAs</div>
                <div class="value"><%= request.getAttribute("totalTAs") %></div>
            </div>
            <div class="summary-card">
                <div class="label">Total Assigned Jobs</div>
                <div class="value"><%= request.getAttribute("totalAssigned") %></div>
            </div>
        </div>

        <% if (reportRows == null || reportRows.isEmpty()) { %>
            <div class="empty">No TA workload data is currently available.</div>
        <% } else { %>
            <table>
                <thead>
                <tr>
                    <th>TA Name</th>
                    <th>TA ID</th>
                    <th>Total Assigned Jobs</th>
                    <th>Assigned Modules</th>
                </tr>
                </thead>
                <tbody>
                <% for (java.util.Map<String, Object> row : reportRows) { %>
                    <tr>
                        <td><strong><%= row.get("username") %></strong></td>
                        <td class="mono"><%= row.get("userId") %></td>
                        <td><%= row.get("workload") %></td>
                        <td><%= row.get("modulesSummary") %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</main>
</body>
</html>
