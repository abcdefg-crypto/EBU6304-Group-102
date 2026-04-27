<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>My Applications - TA Recruitment System</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: #f5f7fb; }
        header { background: #1f3c88; color: #fff; padding: 14px 24px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: #fff; margin-left: 12px; text-decoration: none; font-size: 13px; }
        main { max-width: 980px; margin: 24px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); padding: 22px 28px 28px; }
        .meta { color:#4b5563; font-size: 13px; margin-bottom: 6px; }
        .tag { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; background: #e0ecff; color: #1d4ed8; margin-right: 6px; }
        .tag.accepted { background:#dcfce7; color:#166534; }
        .tag.rejected { background:#fee2e2; color:#991b1b; }
        .tag.pending { background:#e5e7eb; color:#374151; }
        .tag { font-weight: 700; }
        .empty { color:#6b7280; font-size:14px; }
        .btn { border-radius: 999px; padding: 8px 14px; border: 1px solid #cbd5f5; background:#fff; color:#2563eb; font-size: 13px; text-decoration:none; display:inline-block; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #e5e7eb; padding: 10px 12px; text-align: left; vertical-align: top; font-size: 13px; }
        th { background: #f8fafc; color: #1f2937; }
        .reason-muted { color: #6b7280; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>My Applications</strong>
        <span style="margin-left:10px;font-size:13px;opacity:0.9;">Role: <%= request.getAttribute("role") %></span>
    </div>
    <div>
        <a href="<%=request.getContextPath()%>/jobs">Back to Home</a>
        <a href="<%=request.getContextPath()%>/auth/logout">Logout</a>
    </div>
</header>

<main>
    <h2 style="margin-top:0;">Submitted Applications</h2>
    <p class="meta">Shows job, status, and rejection reason when applicable.</p>

    <%
        String submitted = request.getParameter("submitted");
        String withdrawn = request.getParameter("withdrawn");
        String withdrawError = request.getParameter("withdrawError");
        String submittedJobTitle = request.getParameter("jobTitle");
        String submittedAppliedAt = request.getParameter("appliedAt");
    %>
    <% if ("1".equals(submitted)) { %>
        <div style="background:#dcfce7;color:#166534;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
            Application submitted: "<%= submittedJobTitle == null ? "-" : submittedJobTitle %>", date <%= submittedAppliedAt == null ? "-" : submittedAppliedAt %>.
        </div>
    <% } %>
    <% if ("1".equals(withdrawn)) { %>
        <div style="background:#dbeafe;color:#1d4ed8;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
            Application withdrawn successfully.
        </div>
    <% } %>
    <% if (withdrawError != null && !withdrawError.trim().isEmpty()) { %>
        <div style="background:#fee2e2;color:#991b1b;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
            Withdraw failed: <%= withdrawError %>
        </div>
    <% } %>

    <%
        java.util.List<com.bupt.is.model.ApplicationView> applications =
                (java.util.List<com.bupt.is.model.ApplicationView>) request.getAttribute("applications");
        if (applications == null || applications.isEmpty()) {
    %>
        <div class="empty">You have not submitted any applications yet. Go search for jobs first.</div>
    <%
        } else {
    %>
        <table>
            <thead>
                <tr>
                    <th style="width:32%;">Job</th>
                    <th style="width:16%;">Status</th>
                    <th>Reason (What do you lack)</th>
                    <th style="width:16%;">Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (com.bupt.is.model.ApplicationView appView : applications) {
                    String status = appView.getStatus() == null ? "PENDING" : appView.getStatus().trim().toUpperCase();
                    String tagClass = "pending";
                    String statusText = "waiting";
                    if ("ACCEPTED".equals(status)) {
                        tagClass = "accepted";
                        statusText = "success";
                    } else if ("REJECTED".equals(status)) {
                        tagClass = "rejected";
                        statusText = "failed";
                    }
                    String reasonText = "—";
                    if ("REJECTED".equals(status)) {
                        String r = appView.getRejectionReason();
                        reasonText = (r == null || r.trim().isEmpty())
                                ? "(Pending) Rejection reason will be shown here after MO review."
                                : r;
                    }
            %>
                <tr>
                    <td>
                        <div><strong><%= appView.getJobTitle() %></strong></div>
                        <div class="reason-muted">Module: <%= appView.getModule() %></div>
                        <div class="reason-muted">Applied at: <%= appView.getAppliedAt() == null ? "-" : appView.getAppliedAt() %></div>
                        <div style="margin-top:8px;">
                            <a class="btn" href="<%=request.getContextPath()%>/jobs/detail?jobId=<%= appView.getJobId() %>&from=applications">View Job Detail</a>
                        </div>
                    </td>
                    <td>
                        <span class="tag <%= tagClass %>"><%= statusText %></span>
                    </td>
                    <td class="reason-muted"><%= reasonText %></td>
                    <td>
                        <% if (!"ACCEPTED".equals(status)) { %>
                        <form method="post" action="<%=request.getContextPath()%>/applications/withdraw" onsubmit="return confirm('Withdraw this application?');">
                            <input type="hidden" name="appId" value="<%= appView.getApplicationId() %>">
                            <button type="submit" class="btn" style="border-color:#fecaca;color:#dc2626;">Withdraw</button>
                        </form>
                        <% } else { %>
                        <span class="reason-muted">Cannot withdraw accepted application</span>
                        <% } %>
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>
    <%
        }
    %>
</main>
</body>
</html>
