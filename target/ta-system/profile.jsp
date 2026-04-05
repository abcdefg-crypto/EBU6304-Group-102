<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人档案 - TA Recruitment System</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            background: #f5f7fb;
        }
        header {
            background: #1f3c88;
            color: #fff;
            padding: 14px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header .right a {
            color: #fff;
            margin-left: 12px;
            text-decoration: none;
            font-size: 13px;
        }
        main {
            max-width: 980px;
            margin: 24px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
            padding: 22px 28px 28px;
        }
        h2 { margin: 0 0 12px; }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .card {
            border: 1px solid #e1e5f2;
            border-radius: 10px;
            padding: 16px;
            background: #fafbff;
        }
        label { display: block; font-size: 13px; color: #374151; margin-bottom: 6px; }
        input[type="text"], input[type="email"], input[type="file"] {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            box-sizing: border-box;
            margin-bottom: 12px;
        }
        .btn {
            border-radius: 999px;
            padding: 9px 16px;
            border: none;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-outline { background: #fff; color: #2563eb; border: 1px solid #cbd5f5; }
        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 10px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 14px;
        }
        .success {
            background: #dcfce7;
            color: #166534;
            padding: 10px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 14px;
        }
        .muted { color: #6b7280; font-size: 13px; }
        ul { margin: 8px 0 0 18px; padding: 0; }
        li { color: #4b5563; font-size: 13px; margin-bottom: 4px; }
    </style>
</head>
<body>
<header>
    <div>
        <strong>个人档案</strong>
        <span class="muted" style="margin-left:10px;">角色：<%= request.getAttribute("role") %></span>
    </div>
    <div class="right">
        <a href="<%=request.getContextPath()%>/jobs">岗位列表</a>
        <a href="<%=request.getContextPath()%>/auth/logout">退出</a>
    </div>
</header>

<main>
    <%
        String error = (String) request.getAttribute("error");
        String updated = request.getParameter("updated");
        String cv = request.getParameter("cv");
    %>
    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } else if ("1".equals(updated)) { %>
    <div class="success">档案已更新</div>
    <% } else if ("1".equals(cv)) { %>
    <div class="success">CV 上传成功</div>
    <% } %>

    <div class="grid">
        <div class="card">
            <h2 style="font-size:16px;margin-top:0;">档案信息（Story3 / Story4）</h2>
            <p class="muted">用于演示必填项校验与可编辑档案。</p>

            <form action="user/profile" method="post">
                <label>邮箱</label>
                <input type="email" name="email"
                       value="<%= (request.getAttribute("user") != null) ? ((com.bupt.is.model.User)request.getAttribute("user")).getEmail() : "" %>"
                       required>

                <label>姓名</label>
                <input type="text" name="name"
                       value="<%= (request.getAttribute("profile") != null) ? ((com.bupt.is.model.ApplicantProfile)request.getAttribute("profile")).getName() : "" %>"
                       required>

                <label>学号</label>
                <input type="text" name="studentId"
                       value="<%= (request.getAttribute("profile") != null) ? ((com.bupt.is.model.ApplicantProfile)request.getAttribute("profile")).getStudentId() : "" %>"
                       required>

                <%-- 新增：电话号码输入框 (Story 4) --%>
                        <label>电话号码</label>
                        <input type="text" name="phoneNumber"
                               value="<%= (request.getAttribute("profile") != null) ? ((com.bupt.is.model.ApplicantProfile)request.getAttribute("profile")).getPhoneNumber() : "" %>">

                <button type="submit" class="btn btn-primary">保存档案</button>
                <a href="<%=request.getContextPath()%>/user/profile" class="btn btn-outline">刷新</a>
            </form>
        </div>
        <%-- CV 上传部分 (Story 5) --%>
        <div class="card">
            <h2 style="font-size:16px;margin-top:0;">上传简历 CV (Story 5)</h2>
            <form action="<%=request.getContextPath()%>/user/cv/upload" method="post" enctype="multipart/form-data">
                <input type="file" name="cv" accept=".pdf" required>
                <button type="submit" class="btn btn-primary">上传 PDF</button>
            </form>
        </div>

            <div style="margin-bottom:12px;">
                <strong>当前简历：</strong>
                <% if (cvPath == null || cvPath.trim().isEmpty()) { %>
                <span class="muted">未上传</span>
                <% } else { %>
                <a href="<%=request.getContextPath()%>/files/cv?cvPath=<%=cvPath%>">查看/下载 PDF</a>
                <% } %>
            </div>

            <form action="user/cv/upload" method="post" enctype="multipart/form-data">
                <input type="file" name="cv" accept=".pdf" required>
                <button type="submit" class="btn btn-primary">上传 PDF</button>
            </form>
        </div>
    </div>

    <div style="margin-top:16px;">
        <h2 style="font-size:16px;margin:0 0 8px;">本页覆盖迭代 1 的关键交互</h2>
        <ul>
            <li>Story3：创建申请者档案（在注册页完成）</li>
            <li>Story4：编辑申请者档案</li>
            <li>Story5：上传 CV（仅 PDF）</li>
        </ul>
    </div>
</main>
</body>
</html>

