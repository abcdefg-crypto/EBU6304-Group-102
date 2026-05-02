<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Applicant Detail - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        label { display: block; font-size: 13px; color: #374151; margin-bottom: 6px; }
        input[type="text"], input[type="email"], textarea {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            box-sizing: border-box;
            margin-bottom: 12px;
            background: #fff;
            color: #111827;
        }
        textarea { resize: vertical; min-height: 90px; }
        .btn { border-radius: 999px; padding: 8px 14px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 13px; text-decoration:none; display:inline-block; }
        .muted { color: #6b7280; font-size: 13px; }
        .section-title { font-size: 15px; margin: 14px 0 10px; color: #1f2937; }
        .action-bar { margin-top: 14px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; width: 100%; }
        .btn-primary { background:#2563eb; color:#fff; border:none; }
        .top-summary { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin: 8px 0 12px; }
        .status-tag { display:inline-block; padding: 3px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        .status-pending { background:#e5e7eb; color:#374151; }
        .status-accepted { background:#dcfce7; color:#166534; }
        .status-rejected { background:#fee2e2; color:#991b1b; }
        .cv-layout { display: flex; gap: 14px; align-items: stretch; margin-top: 6px; }
        .cv-left { flex: 1; min-width: 280px; }
        .cv-right { width: 420px; max-width: 48%; }
        .pdf-preview { height: 360px; border: 1px solid #e1e5f2; border-radius: 10px; background: #fff; overflow-y: auto; overflow-x: hidden; }
        .pdf-preview iframe { width: 100%; height: 100%; border: 0; display: block; }
        @media (max-width: 920px) { .cv-layout { flex-direction: column; } .cv-right { width: 100%; max-width: 100%; } }
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
    String roleAttrDetail = (String) request.getAttribute("role");
    boolean adminRoleDetail = "ADMIN".equalsIgnoreCase(roleAttrDetail) || "ADMINISTRATOR".equalsIgnoreCase(roleAttrDetail);
%>
<header>
    <div>
        <strong>Applicant Detail</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <%
            com.bupt.is.model.Job job = (com.bupt.is.model.Job) request.getAttribute("job");
            com.bupt.is.model.User applicant = (com.bupt.is.model.User) request.getAttribute("applicant");
            com.bupt.is.model.ApplicantProfile profile = (com.bupt.is.model.ApplicantProfile) request.getAttribute("profile");
            com.bupt.is.model.Application appInfo = (com.bupt.is.model.Application) request.getAttribute("application");
        %>
        <a href="<%=request.getContextPath()%>/jobs/applicants?jobId=<%= job != null ? job.getJobId() : "" %>"><%= adminRoleDetail ? "Back to Applicants" : "Back to List" %></a>
        <% if (adminRoleDetail) { %>
            <a href="<%=request.getContextPath()%>/jobs?view=workload-overview">Workload Overview</a>
        <% } %>
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <div class="card">
        <h2 style="font-size:16px;margin-top:0;">Applicant Information</h2>
        <p class="muted"><%= adminRoleDetail ? "Admin read-only view of application data, CV, and profile." : "MO can review application data, CV, and profile, then accept or reject below." %></p>

        <div class="section-title">Application Info</div>
        <label>Job</label>
        <input type="text" readonly value="<%= job != null ? job.getTitle() : "-" %>">

        <label>Status</label>
        <%
            String s0 = appInfo != null && appInfo.getStatus() != null ? appInfo.getStatus().trim().toUpperCase() : "PENDING";
            String statusClass = "status-pending";
            if ("ACCEPTED".equals(s0)) statusClass = "status-accepted";
            else if ("REJECTED".equals(s0)) statusClass = "status-rejected";
        %>
        <div>
            <span class="status-tag <%= statusClass %>"><%= s0 %></span>
        </div>

        <label>Applied Date</label>
        <input type="text" readonly value="<%= appInfo != null ? appInfo.getAppliedAt() : "-" %>">

        <div class="cv-layout">
            <div class="cv-left">
                <label>CV</label>
                <div style="margin-bottom: 10px;">
                    <% if (applicant != null && applicant.getCvPath() != null && !applicant.getCvPath().trim().isEmpty()) { %>
                        <a class="btn" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=applicant.getCvPath()%>" target="_blank">Open PDF</a>
                        <a class="btn" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=applicant.getCvPath()%>&download=1">Download PDF</a>
                    <% } else { %>
                        <span class="muted">Not uploaded</span>
                    <% } %>
                </div>

                <label>System Match Score</label>
                <input type="text" readonly value="">
            </div>

            <div class="cv-right">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                    <strong>Preview</strong>
                    <% if (applicant != null && applicant.getCvPath() != null && !applicant.getCvPath().trim().isEmpty()) { %>
                        <a class="muted" style="text-decoration:none;" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=applicant.getCvPath()%>" target="_blank">Open in new tab</a>
                    <% } %>
                </div>
                <div class="pdf-preview">
                    <% if (applicant == null || applicant.getCvPath() == null || applicant.getCvPath().trim().isEmpty()) { %>
                        <div class="muted" style="padding:12px;">No CV uploaded yet.</div>
                    <% } else { %>
                        <iframe src="<%=request.getContextPath()%>/files/cv?cvPath=<%=applicant.getCvPath()%>#toolbar=0&navpanes=0"></iframe>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="section-title">Profile Information</div>
        <label>Name</label>
        <input type="text" readonly value="<%= profile != null && profile.getName() != null ? profile.getName() : "-" %>">

        <label>Username</label>
        <input type="text" readonly value="<%= applicant != null && applicant.getUsername() != null ? applicant.getUsername() : "-" %>">

        <label>Email</label>
        <input type="email" readonly value="<%= applicant != null && applicant.getEmail() != null ? applicant.getEmail() : "-" %>">

        <label>Student ID</label>
        <input type="text" readonly value="<%= profile != null && profile.getStudentId() != null ? profile.getStudentId() : "-" %>">

        <label>Phone Number</label>
        <input type="text" readonly value="<%= profile != null && profile.getPhoneNumber() != null ? profile.getPhoneNumber() : "-" %>">

        <label>Skills</label>
        <textarea readonly><%= profile != null && profile.getSkills() != null ? profile.getSkills() : "-" %></textarea>

        <label>Self Introduction</label>
        <textarea readonly><%= profile != null && profile.getSelfIntroduction() != null ? profile.getSelfIntroduction() : "-" %></textarea>

        <% if (!adminRoleDetail) { %>
        <div class="action-bar">
            <form action="<%=request.getContextPath()%>/applications/status" method="post" style="width:100%;">
                <input type="hidden" name="jobId" value="<%= job != null ? job.getJobId() : "" %>">
                <input type="hidden" name="appId" value="<%= appInfo != null ? appInfo.getApplicationId() : "" %>">
                <input type="hidden" name="status" value="ACCEPTED">
                <button type="submit" class="btn btn-primary" style="width:100%;">Accept</button>
            </form>
            <form action="<%=request.getContextPath()%>/applications/status" method="post" style="width:100%;" class="reject-form">
                <input type="hidden" name="jobId" value="<%= job != null ? job.getJobId() : "" %>">
                <input type="hidden" name="appId" value="<%= appInfo != null ? appInfo.getApplicationId() : "" %>">
                <input type="hidden" name="status" value="REJECTED">
                <input type="hidden" name="reason" value="">
                <button type="button" class="btn" style="width:100%;" onclick="openRejectModal(this.form)">Reject</button>
            </form>
        </div>
        <% } %>

    </div>
</main>
<% if (!adminRoleDetail) { %>
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
