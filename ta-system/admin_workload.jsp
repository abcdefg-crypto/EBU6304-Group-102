<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>TA Workload Overview - Admin</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 1120px; margin: 24px auto; padding: 0 16px; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; margin-bottom: 24px; }

        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { border: 1px solid #e1e5f2; border-radius: 12px; padding: 18px; text-align: center; background: #fafbff; }
        .summary-card .label { font-size: 12px; color: #6b7280; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 4px; }
        .summary-card .value { font-size: 28px; font-weight: 700; color: #111827; }
        .summary-card .sub { font-size: 12px; color: #9ca3af; margin-top: 2px; }

        h2 { margin: 0 0 6px; font-size: 20px; color: #111827; }
        .section-title { margin: 24px 0 12px; font-size: 17px; color: #1f2937; }

        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #e5e7eb; padding: 10px 12px; text-align: left; font-size: 13px; }
        th { background: #f8fafc; color: #1f2937; font-weight: 600; }

        .workload-bar-wrap { display: flex; align-items: center; gap: 10px; }
        .workload-bar-bg { flex: 1; height: 22px; background: #f3f4f6; border-radius: 11px; overflow: hidden; min-width: 100px; }
        .workload-bar-fill { height: 100%; border-radius: 11px; transition: width .3s; }
        .workload-bar-fill.low { background: linear-gradient(90deg, #86efac, #22c55e); }
        .workload-bar-fill.mid { background: linear-gradient(90deg, #fde68a, #f59e0b); }
        .workload-bar-fill.high { background: linear-gradient(90deg, #fca5a5, #ef4444); }
        .workload-count { font-weight: 700; font-size: 14px; min-width: 24px; text-align: center; }

        .diff-tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; font-weight: 600; }
        .diff-above { background: #fee2e2; color: #991b1b; }
        .diff-below { background: #dcfce7; color: #166534; }
        .diff-avg { background: #e0ecff; color: #1d4ed8; }

        .muted { color: #6b7280; font-size: 13px; }
        .empty { color: #6b7280; font-size: 14px; margin-top: 12px; }

        .all-jobs-table { margin-top: 16px; }
        .all-jobs-table td { font-size: 13px; }

        .tab-nav { display: flex; gap: 0; border-bottom: 2px solid #e5e7eb; margin-bottom: 20px; }
        .tab-btn { padding: 10px 20px; border: none; background: none; font-size: 14px; color: #6b7280; cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; }
        .tab-btn.active { color: #2563eb; border-bottom-color: #2563eb; font-weight: 600; }

        .high-diff { background: #fff5f5; }
    </style>
</head>
<body>
<%
    String role = (String) request.getAttribute("role");
    java.util.List<java.util.Map<String, Object>> taWorkloads =
            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("taWorkloads");
    java.util.List<java.util.Map<String, String>> allAssignedJobs =
            (java.util.List<java.util.Map<String, String>>) request.getAttribute("allAssignedJobs");
    int totalTAs = (Integer) request.getAttribute("totalTAs");
    int totalAssigned = (Integer) request.getAttribute("totalAssigned");
    int maxWorkload = (Integer) request.getAttribute("maxWorkload");
    int minWorkload = (Integer) request.getAttribute("minWorkload");
    double avgWorkload = (Double) request.getAttribute("avgWorkload");
%>
<header>
    <div>
        <strong>TA Workload Overview</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Admin Panel | Role: <%= role %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">Admin Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <!-- Summary Cards -->
    <div class="summary-cards">
        <div class="summary-card">
            <div class="label">Total TAs</div>
            <div class="value"><%= totalTAs %></div>
        </div>
        <div class="summary-card">
            <div class="label">Total Assigned Jobs</div>
            <div class="value"><%= totalAssigned %></div>
        </div>
        <div class="summary-card">
            <div class="label">Average Workload</div>
            <div class="value"><%= avgWorkload %></div>
            <div class="sub">jobs per TA</div>
        </div>
        <div class="summary-card">
            <div class="label">Max / Min</div>
            <div class="value" style="font-size:24px;"><%= maxWorkload %> / <%= minWorkload %></div>
            <div class="sub">jobs per TA</div>
        </div>
    </div>

    <!-- Workload Comparison Panel -->
    <div class="panel">
        <h2>TA Workload Comparison</h2>
        <p class="muted">Workload is calculated as the number of accepted (assigned) TA jobs per student.
            The bar chart makes workload differences immediately visible.</p>

        <% if (taWorkloads == null || taWorkloads.isEmpty()) { %>
            <div class="empty">No TAs found in the system.</div>
        <% } else { %>
            <table>
                <thead>
                <tr>
                    <th style="width:22%;">TA Name</th>
                    <th style="width:50%;">Workload</th>
                    <th style="width:15%;">Assigned Jobs</th>
                    <th style="width:13%;">vs. Average</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (java.util.Map<String, Object> ta : taWorkloads) {
                        String username = (String) ta.get("username");
                        int wl = (Integer) ta.get("workload");
                        java.util.List<java.util.Map<String, String>> acceptedApps =
                                (java.util.List<java.util.Map<String, String>>) ta.get("acceptedApplications");

                        String barClass;
                        if (wl > avgWorkload) {
                            barClass = "high";
                        } else if (wl < avgWorkload) {
                            barClass = "low";
                        } else {
                            barClass = "mid";
                        }

                        int barPercent = maxWorkload > 0 ? (int) Math.round((double) wl / maxWorkload * 100) : 0;

                        double diff = wl - avgWorkload;
                        String diffText;
                        String diffClass;
                        if (diff > 0) {
                            diffText = "+" + String.format("%.1f", diff);
                            diffClass = "diff-above";
                        } else if (diff < 0) {
                            diffText = String.format("%.1f", diff);
                            diffClass = "diff-below";
                        } else {
                            diffText = "0";
                            diffClass = "diff-avg";
                        }

                        boolean highDiff = wl > avgWorkload + 1;
                %>
                <tr <%= highDiff ? "class=\"high-diff\"" : "" %>>
                    <td><strong><%= username %></strong></td>
                    <td>
                        <div class="workload-bar-wrap">
                            <div class="workload-bar-bg">
                                <div class="workload-bar-fill <%= barClass %>" style="width:<%= barPercent %>%"></div>
                            </div>
                            <span class="workload-count"><%= wl %></span>
                        </div>
                    </td>
                    <td>
                        <% for (java.util.Map<String, String> app : acceptedApps) { %>
                            <div style="font-size:12px; margin-bottom:2px;" title="<%= app.get("jobModule") %>">
                                <%= app.get("jobTitle") %>
                            </div>
                        <% } %>
                        <% if (acceptedApps.isEmpty()) { %>
                            <span class="muted">-</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="diff-tag <%= diffClass %>"><%= diffText %></span>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

    <!-- All Assigned Jobs Panel -->
    <div class="panel">
        <h2>All Assigned TA Jobs</h2>
        <p class="muted">Every accepted application representing an assigned TA job.</p>

        <% if (allAssignedJobs == null || allAssignedJobs.isEmpty()) { %>
            <div class="empty">No assigned TA jobs yet.</div>
        <% } else { %>
            <table class="all-jobs-table">
                <thead>
                <tr>
                    <th>TA Name</th>
                    <th>Job Title</th>
                    <th>Module</th>
                    <th>Applied Date</th>
                </tr>
                </thead>
                <tbody>
                <% for (java.util.Map<String, String> job : allAssignedJobs) { %>
                <tr>
                    <td><strong><%= job.get("taName") %></strong></td>
                    <td><%= job.get("jobTitle") %></td>
                    <td><%= job.get("jobModule") %></td>
                    <td><%= job.get("appliedAt") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</main>
</body>
</html>
