<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Create Profile - TA Recruitment System</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #1d4ed8 0%, #0ea5e9 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            background: #ffffff;
            border-radius: 18px;
            padding: 28px 40px 32px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.35);
            width: 420px;
        }
        h1 { margin: 0 0 4px; font-size: 22px; color: #111827; }
        p.subtitle { margin: 0 0 18px; font-size: 13px; color: #6b7280; }
        label { display: block; font-size: 13px; color: #374151; margin-bottom: 6px; }
        input[type="text"], input[type="password"], input[type="email"], select {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            box-sizing: border-box;
        }
        .field { margin-bottom: 14px; }
        .btn {
            width: 100%;
            border-radius: 999px;
            border: none;
            padding: 9px 12px;
            background: #2563eb;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            margin-top: 10px;
        }
        .back-link {
            display: inline-block;
            margin-top: 12px;
            font-size: 12px;
            color: #2563eb;
            text-decoration: none;
        }
        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 10px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 14px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Create Profile</h1>

    <%
        String error = (String) request.getAttribute("error");
    %>
    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form action="<%=request.getContextPath()%>/user/register" method="post">
        <div class="field">
            <label>Username</label>
            <input type="text" name="username" required>
        </div>
        <div class="field">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        <div class="field">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        <div class="field">
            <label>Name (required)</label>
            <input type="text" name="name" required>
        </div>
        <div class="field">
            <label>Student ID (required)</label>
            <input type="text" name="studentId" required>
        </div>
        <div class="field">
            <label>Role</label>
            <select name="role">
                <option value="TA" selected>TA (Applicant)</option>
                <option value="MO">MO (Module Owner)</option>
                <option value="ADMIN">Admin</option>
            </select>
        </div>

        <button type="submit" class="btn">Create</button>
    </form>

    <a href="<%=request.getContextPath()%>/index.jsp" class="back-link">Back to Home</a>
</div>
</body>
</html>

