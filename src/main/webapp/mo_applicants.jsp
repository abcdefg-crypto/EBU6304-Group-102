<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Manage Applicants - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #e5e7eb; padding: 10px 12px; text-align: left; font-size: 13px; }
        th { background: #f8fafc; color: #1f2937; }
        .muted { color:#6b7280; font-size:13px; }
        .btn { border-radius: 999px; padding: 8px 14px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 13px; text-decoration:none; display:inline-block; }
        .empty { color:#6b7280; font-size:14px; margin-top: 12px; }
        .success { background: #dcfce7; color: #166534; padding: 10px 12px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px 12px; border-radius: 10px; font-size: 13px; margin-bottom: 10px; }
        .reason-input { width: 220px; padding: 7px 9px; border:1px solid #d1d5db; border-radius:8px; font-size:12px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>Manage Applicants</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs?view=manage-applicants">Back to Job List</a>
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <%
        com.bupt.is.model.Job job = (com.bupt.is.model.Job) request.getAttribute("job");
        java.util.List<java.util.Map<String, String>> rows =
                (java.util.List<java.util.Map<String, String>>) request.getAttribute("rows");
        String statusUpdated = request.getParameter("statusUpdated");
        String statusError = request.getParameter("statusError");
    %>
    <h2 style="margin-top:0;">Who applied</h2>
    <p class="muted">Job: <strong><%= job != null ? job.getTitle() : "-" %></strong></p>
    <% if ("1".equals(statusUpdated)) { %>
        <div class="success">Application status updated.</div>
    <% } %>
    <% if ("1".equals(statusError)) { %>
        <div class="error">Failed to update status. Please try again.</div>
    <% } %>

    <% if (rows == null || rows.isEmpty()) { %>
        <div class="empty">No applicants for this job yet.</div>
    <% } else { %>
        <table>
            <thead>
            <tr>
                <th style="width:30%;">Name</th>
                <th style="width:25%;">Student ID</th>
                <th style="width:20%;">Status</th>
                <th style="width:12%;">Detail</th>
                <th style="width:28%;">Accept / Reject</th>
            </tr>
            </thead>
            <tbody>
            <% for (java.util.Map<String, String> row : rows) { %>
                <tr>
                    <td><%= row.get("name") %></td>
                    <td><%= row.get("studentId") %></td>
                    <td><%= row.get("status") %></td>
                    <td style="white-space: nowrap;">
                        <a class="btn" href="<%=request.getContextPath()%>/jobs/applicant-detail?jobId=<%= job.getJobId() %>&applicantId=<%= row.get("applicantId") %>">Detail</a>
                    </td>
                    <td style="white-space: nowrap;">
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= row.get("applicationId") %>">
                            <input type="hidden" name="status" value="ACCEPTED">
                            <button type="submit" class="btn">Accept</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;" onsubmit="return submitRejectWithReason(this);">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= row.get("applicationId") %>">
                            <input type="hidden" name="status" value="REJECTED">
                            <input type="hidden" name="reason" value="">
                            <button type="submit" class="btn">Reject</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</main>
<script>
    function submitRejectWithReason(form) {
        var reason = window.prompt("Please enter rejection reason:", "");
        if (reason === null) {
            return false;
        }
        reason = reason.trim();
        if (!reason) {
            window.alert("Rejection reason cannot be empty");
            return false;
        }
        form.querySelector('input[name="reason"]').value = reason;
        return true;
    }
</script>
</body>
</html>
