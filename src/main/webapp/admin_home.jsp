<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - TA Recruitment</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 18px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; padding: 0 16px; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 26px 28px; }
        .panel h2 { margin: 0 0 8px; font-size: 24px; color: #111827; }
        .panel .muted { color: #6b7280; line-height: 1.6; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 18px; margin-top: 24px; }
        .card { border: 1px solid #e5e7eb; border-radius: 16px; padding: 24px; background: #f8fafc; color: #111827; text-decoration: none; transition: transform .2s ease, box-shadow .2s ease; }
        .card:hover { transform: translateY(-2px); box-shadow: 0 16px 40px rgba(15, 23, 42, 0.08); }
        .card-title { font-size: 18px; font-weight: 700; margin-bottom: 6px; }
        .card-sub { color: #6b7280; font-size: 13px; line-height: 1.5; }
    </style>
</head>
<body>
<%
    String role = (String) request.getAttribute("role");
%>
<header>
    <div>
        <strong>Admin Dashboard</strong>
        <span style="margin-left:12px; opacity:0.9; font-size:13px;">Role: <%= role %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">Jobs</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>
<main>
    <div class="panel">
        <h2>Admin Actions</h2>
        <p class="muted">Select one of the functions below to review all applications, inspect TA workloads, or view the workload report.</p>
        <div class="dashboard-grid">
            <a class="card" href="<%=request.getContextPath()%>/admin/applications">
                <div class="card-title">Applications</div>
                <div class="card-sub">View and monitor all job applications.</div>
            </a>
            <a class="card" href="<%=request.getContextPath()%>/admin/workload">
                <div class="card-title">Workload</div>
                <div class="card-sub">Check TA workload distribution and accepted jobs.</div>
            </a>
            <a class="card" href="<%=request.getContextPath()%>/admin/report">
                <div class="card-title">Report</div>
                <div class="card-sub">Generate the TA workload summary report.</div>
            </a>
        </div>
    </div>
</main>
</body>
</html>
