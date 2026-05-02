<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Profile - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header .right a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .grid { display: grid; grid-template-columns: 1fr; gap: 16px; }
        .card { border: 1px solid #e1e5f2; border-radius: 10px; padding: 16px; background: #fafbff; }
        label { display: block; font-size: 13px; color: #374151; margin-bottom: 6px; }
        input[type="text"], input[type="email"], input[type="file"], textarea { width: 100%; padding: 9px 11px; border-radius: 9px; border: 1px solid #d1d5db; font-size: 13px; box-sizing: border-box; margin-bottom: 12px; }
        textarea { resize: vertical; min-height: 90px; }
        .btn { border-radius: 999px; padding: 9px 16px; border: none; font-size: 14px; cursor: pointer; text-decoration: none; display: inline-block; margin-right: 10px; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-outline { background: #fff; color: #2563eb; border: 1px solid #cbd5f5; }
        .file-input-native { display: none; }
        .upload-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .file-name { color:#6b7280; font-size: 13px; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 14px; }
        .success { background: #dcfce7; color: #166534; padding: 10px; border-radius: 10px; font-size: 13px; margin-bottom: 14px; }
        .muted { color: #6b7280; font-size: 13px; }
        ul { margin: 8px 0 0 18px; padding: 0; }
        li { color: #4b5563; font-size: 13px; margin-bottom: 4px; }
        .cv-layout { display: flex; gap: 14px; align-items: stretch; }
        .cv-left { flex: 1; min-width: 300px; }
        .cv-right { width: 420px; max-width: 48%; }
        .pdf-preview {
            height: 320px;
            border: 1px solid #e1e5f2;
            border-radius: 10px;
            background: #fff;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .pdf-preview iframe {
            width: 100%;
            height: 100%;
            border: 0;
            display: block;
        }
        @media (max-width: 920px) {
            .cv-layout { flex-direction: column; }
            .cv-right { width: 100%; max-width: 100%; }
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>Profile</strong>
        <span class="muted" style="margin-left:10px;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div class="right">
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <%
        String error = (String) request.getAttribute("error");
        String updated = request.getParameter("updated");
        String cv = request.getParameter("cv");
        String cvDeleted = request.getParameter("cvDeleted");
        com.bupt.is.model.User user = (com.bupt.is.model.User) request.getAttribute("user");
        com.bupt.is.model.ApplicantProfile profile = (com.bupt.is.model.ApplicantProfile) request.getAttribute("profile");
        String cvPath = user != null ? user.getCvPath() : null;
    %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } else if ("1".equals(updated)) { %>
        <div class="success">Profile updated</div>
    <% } else if ("1".equals(cv)) { %>
        <div class="success">CV uploaded successfully</div>
    <% } else if ("1".equals(cvDeleted)) { %>
        <div class="success">Uploaded CV deleted</div>
    <% } %>

    <div class="grid">
        <div class="card">
            <h2 style="font-size:16px;margin-top:0;">Upload CV</h2>
            <div class="cv-layout">
                <div class="cv-left">
                    <div style="margin-bottom:12px;">
                        <strong>Current CV:</strong>
                        <% if (cvPath == null || cvPath.trim().isEmpty()) { %>
                            <span class="muted">Not uploaded</span>
                        <% } else { %>
                            <a href="<%=request.getContextPath()%>/files/cv?cvPath=<%=cvPath%>" target="_blank">Open PDF</a>
                            <span class="muted"> | </span>
                            <a href="<%=request.getContextPath()%>/files/cv?cvPath=<%=cvPath%>&download=1">Download PDF</a>
                        <% } %>
                    </div>

                    <form id="cvUploadForm" action="<%=request.getContextPath()%>/user/cv/upload" method="post" enctype="multipart/form-data">
                        <input id="cvFile" class="file-input-native" type="file" name="cv" accept=".pdf" required>
                        <div class="upload-row">
                            <button id="uploadCvBtn" type="button" class="btn btn-primary">Upload PDF</button>
                            <span id="cvFileName" class="file-name">No file chosen</span>
                            <span class="muted" style="font-size:12px;">
                                <% if (cvPath != null && !cvPath.trim().isEmpty()) { %>
                                    Uploading a new file will overwrite the old one.
                                <% } else { %>
                                    PDF only.
                                <% } %>
                            </span>
                        </div>
                    </form>

                    <% if (cvPath != null && !cvPath.trim().isEmpty()) { %>
                        <form action="<%=request.getContextPath()%>/user/cv/delete" method="post" style="margin-top:10px;">
                            <button type="submit" class="btn btn-outline">Delete Uploaded CV</button>
                        </form>
                    <% } %>
                </div>

                <div class="cv-right">
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                        <strong>Preview</strong>
                        <% if (cvPath != null && !cvPath.trim().isEmpty()) { %>
                            <a class="muted" style="text-decoration:none;" href="<%=request.getContextPath()%>/files/cv?cvPath=<%=cvPath%>" target="_blank">Open in new tab</a>
                        <% } %>
                    </div>
                    <div class="pdf-preview">
                        <% if (cvPath == null || cvPath.trim().isEmpty()) { %>
                            <div class="muted" style="padding:12px;">No CV uploaded yet.</div>
                        <% } else { %>
                            <iframe src="<%=request.getContextPath()%>/files/cv?cvPath=<%=cvPath%>#toolbar=0&navpanes=0"></iframe>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <h2 style="font-size:16px;margin-top:0;">Profile Information</h2>
            <p class="muted">Complete your profile and CV before applying for jobs.</p>
            <form action="<%=request.getContextPath()%>/user/profile" method="post">
                <label>Email</label>
                <input type="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" required>

                <label>Name</label>
                <input type="text" name="name" value="<%= profile != null ? profile.getName() : "" %>" required>

                <label>Student ID</label>
                <input type="text" name="studentId" value="<%= profile != null ? profile.getStudentId() : "" %>" required>

                <label>Phone Number</label>
                <input type="text" name="phoneNumber" value="<%= profile != null ? profile.getPhoneNumber() : "" %>">

                <label>Skills</label>
                <textarea name="skills" placeholder="e.g. Java, SQL, Web Development"><%= profile != null && profile.getSkills() != null ? profile.getSkills() : "" %></textarea>

                <label>Self Introduction</label>
                <textarea name="selfIntroduction" placeholder="Briefly introduce your experience and strengths"><%= profile != null && profile.getSelfIntroduction() != null ? profile.getSelfIntroduction() : "" %></textarea>

                <button type="submit" class="btn btn-primary">Save Profile</button>
                <a href="<%=request.getContextPath()%>/user/profile" class="btn btn-outline">Refresh</a>
                <a href="<%=request.getContextPath()%>/jobs" class="btn btn-outline">Back to Home</a>
            </form>
        </div>
    </div>

</main>
<script>
    (function () {
        var input = document.getElementById("cvFile");
        var nameText = document.getElementById("cvFileName");
        var btn = document.getElementById("uploadCvBtn");
        var form = document.getElementById("cvUploadForm");
        if (!input || !nameText) return;

        if (btn) {
            btn.addEventListener("click", function () {
                input.click();
            });
        }

        input.addEventListener("change", function () {
            if (input.files && input.files.length > 0) {
                nameText.textContent = input.files[0].name;
                // Auto submit after picking a PDF (single-button UX).
                if (form) {
                    form.submit();
                }
            } else {
                nameText.textContent = "No file chosen";
            }
        });
    })();
</script>
</body>
</html>
