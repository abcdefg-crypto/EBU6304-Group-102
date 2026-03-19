<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>创建档案 - TA Recruitment System</title>
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
    <h1>创建申请者档案</h1>
    <p class="subtitle">Iteration 1：为登录创建用户，并填写姓名/邮箱/学号。</p>

    <%
        String error = (String) request.getAttribute("error");
    %>
    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form action="user/register" method="post">
        <div class="field">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="field">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <div class="field">
            <label>邮箱</label>
            <input type="email" name="email" required>
        </div>
        <div class="field">
            <label>姓名（档案必填）</label>
            <input type="text" name="name" required>
        </div>
        <div class="field">
            <label>学号（档案必填）</label>
            <input type="text" name="studentId" required>
        </div>
        <div class="field">
            <label>角色</label>
            <select name="role">
                <option value="TA" selected>TA（申请者）</option>
                <option value="MO">MO（课程负责人）</option>
                <option value="ADMIN">Admin（演示用）</option>
            </select>
        </div>

        <button type="submit" class="btn">创建并返回登录</button>
    </form>

    <a href="login.jsp" class="back-link">返回登录</a>
    <a href="index.jsp" class="back-link">返回 Iteration 1 总览</a>
</div>
</body>
</html>

