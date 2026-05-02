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
        .status-tag { display:inline-block; padding: 3px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        .status-pending { background:#e5e7eb; color:#374151; }
        .status-accepted { background:#dcfce7; color:#166534; }
        .status-rejected { background:#fee2e2; color:#991b1b; }
        .modal-mask { position: fixed; inset: 0; background: rgba(15,23,42,.55); display:none; align-items:center; justify-content:center; padding: 18px; z-index: 9999; }
        .modal { width: 520px; max-width: 100%; background:#fff; border-radius: 14px; box-shadow: 0 20px 60px rgba(15,23,42,.35); padding: 16px; }
        .modal h3 { margin: 0 0 10px; font-size: 16px; color:#111827; }
        .modal textarea { width: 100%; min-height: 110px; border-radius: 10px; border:1px solid #d1d5db; padding: 10px; font-size: 13px; box-sizing: border-box; resize: vertical; }
        .modal-actions { display:flex; gap: 10px; justify-content:flex-end; margin-top: 12px; }
        .btn-danger { background:#dc2626; color:#fff; border:none; }
    </style>
</head>
<body>
<%
    String roleAttr = (String) request.getAttribute("role");
    boolean adminRole = "ADMIN".equalsIgnoreCase(roleAttr) || "ADMINISTRATOR".equalsIgnoreCase(roleAttr);
%>
<header>
    <div>
        <strong>Manage Applicants</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <% if (adminRole) { %>
            <a href="<%=request.getContextPath()%>/jobs?view=workload-overview">Back to Workload Overview</a>
        <% } else { %>
            <a href="<%=request.getContextPath()%>/jobs?view=manage-applicants">Back to Job List</a>
        <% } %>
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
                <% if (!adminRole) { %>
                <th style="width:28%;">Accept / Reject</th>
                <% } %>
            </tr>
            </thead>
            <tbody>
            <% for (java.util.Map<String, String> row : rows) { %>
                <tr>
                    <td><%= row.get("name") %></td>
                    <td><%= row.get("studentId") %></td>
                    <td>
                        <%
                            String s0 = row.get("status") == null ? "PENDING" : row.get("status").trim().toUpperCase();
                            String statusClass = "status-pending";
                            if ("ACCEPTED".equals(s0)) statusClass = "status-accepted";
                            else if ("REJECTED".equals(s0)) statusClass = "status-rejected";
                        %>
                        <span class="status-tag <%= statusClass %>"><%= s0 %></span>
                    </td>
                    <td style="white-space: nowrap;">
                        <a class="btn" href="<%=request.getContextPath()%>/jobs/applicant-detail?jobId=<%= job.getJobId() %>&applicantId=<%= row.get("applicantId") %>">Detail</a>
                    </td>
                    <% if (!adminRole) { %>
                    <td style="white-space: nowrap;">
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= row.get("applicationId") %>">
                            <input type="hidden" name="status" value="ACCEPTED">
                            <button type="submit" class="btn">Accept</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/applications/status" method="post" style="display:inline;" class="reject-form">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                            <input type="hidden" name="appId" value="<%= row.get("applicationId") %>">
                            <input type="hidden" name="status" value="REJECTED">
                            <input type="hidden" name="reason" value="">
                            <button type="button" class="btn" onclick="openRejectModal(this.form)">Reject</button>
                        </form>
                    </td>
                    <% } %>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</main>
<% if (!adminRole) { %>
<div id="rejectModalMask" class="modal-mask" role="dialog" aria-modal="true">
    <div class="modal">
        <h3>Please enter rejection reason:</h3>
        <textarea id="rejectReasonInput" placeholder="Type the reason here..."></textarea>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeRejectModal()">Cancel</button>
            <button type="button" class="btn btn-danger" onclick="confirmReject()">Confirm</button>
        </div>
    </div>
</div>
<script>
    var __rejectForm = null;
    function openRejectModal(form) {
        __rejectForm = form;
        var mask = document.getElementById("rejectModalMask");
        var input = document.getElementById("rejectReasonInput");
        if (!mask || !input) return;
        input.value = "";
        mask.style.display = "flex";
        setTimeout(function () { input.focus(); }, 0);
    }
    function closeRejectModal() {
        var mask = document.getElementById("rejectModalMask");
        if (mask) mask.style.display = "none";
        __rejectForm = null;
    }
    function confirmReject() {
        if (!__rejectForm) return;
        var input = document.getElementById("rejectReasonInput");
        var reason = input ? input.value.trim() : "";
        if (!reason) {
            if (input) input.focus();
            return;
        }
        var hidden = __rejectForm.querySelector('input[name="reason"]');
        if (hidden) hidden.value = reason;
        __rejectForm.submit();
    }
    (function () {
        var mask = document.getElementById("rejectModalMask");
        if (!mask) return;
        mask.addEventListener("click", function (e) {
            if (e.target === mask) closeRejectModal();
        });
        document.addEventListener("keydown", function (e) {
            if (e.key === "Escape") closeRejectModal();
        });
    })();
</script>
<% } %>
</body>
</html>
