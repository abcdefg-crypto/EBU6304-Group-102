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
    </style>
</head>
<body>
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
        <a href="<%=request.getContextPath()%>/jobs/applicants?jobId=<%= job != null ? job.getJobId() : "" %>">Back to List</a>
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <div class="card">
        <h2 style="font-size:16px;margin-top:0;">Applicant Information</h2>
        <p class="muted">MO can review application data, CV, and profile, then accept or reject below.</p>

        <div class="section-title">Application Info</div>
        <label>Job</label>
        <input type="text" readonly value="<%= job != null ? job.getTitle() : "-" %>">

        <label>Status</label>
        <input type="text" readonly value="<%= appInfo != null ? appInfo.getStatus() : "-" %>">

        <label>Applied Date</label>
        <input type="text" readonly value="<%= appInfo != null ? appInfo.getAppliedAt() : "-" %>">

        <div class="top-summary">
            <div>
                <label>CV</label>
                <div>
                    <% if (applicant != null && applicant.getCvPath() != null && !applicant.getCvPath().trim().isEmpty()) { %>
                        <a class="btn" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=applicant.getCvPath()%>">View CV PDF</a>
                    <% } else { %>
                        <span class="muted">Not uploaded</span>
                    <% } %>
                </div>
            </div>
            <div>
                <label>System Match Score</label>
                <input type="text" readonly value="">
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

        <div class="action-bar">
            <form action="<%=request.getContextPath()%>/applications/status" method="post" style="width:100%;">
                <input type="hidden" name="jobId" value="<%= job != null ? job.getJobId() : "" %>">
                <input type="hidden" name="appId" value="<%= appInfo != null ? appInfo.getApplicationId() : "" %>">
                <input type="hidden" name="status" value="ACCEPTED">
                <button type="submit" class="btn btn-primary" style="width:100%;">Accept</button>
            </form>
            <form action="<%=request.getContextPath()%>/applications/status" method="post" style="width:100%;" onsubmit="return submitRejectWithReason(this);">
                <input type="hidden" name="jobId" value="<%= job != null ? job.getJobId() : "" %>">
                <input type="hidden" name="appId" value="<%= appInfo != null ? appInfo.getApplicationId() : "" %>">
                <input type="hidden" name="status" value="REJECTED">
                <input type="hidden" name="reason" value="">
                <button type="submit" class="btn" style="width:100%;">Reject</button>
            </form>
        </div>

    </div>
</main>
<script>
    function submitRejectWithReason(form) {
        var reason = window.prompt("Please enter rejection reason:", "");
        if (reason === null) return false;
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
