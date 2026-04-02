<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - TA Recruitment System</title>
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
            padding: 32px 40px 36px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.35);
            width: 360px;
        }
        h1 {
            margin: 0 0 4px;
            font-size: 22px;
            color: #111827;
        }
        p.subtitle {
            margin: 0 0 20px;
            font-size: 13px;
            color: #6b7280;
        }
        label {
            display: block;
            font-size: 13px;
            color: #374151;
            margin-bottom: 6px;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 9px 11px;
            border-radius: 9px;
            border: 1px solid #d1d5db;
            font-size: 13px;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #2563eb;
            outline: none;
            box-shadow: 0 0 0 1px #2563eb33;
        }
        .field {
            margin-bottom: 14px;
        }
        .btn {
            width: 100%;
            border-radius: 999px;
            border: none;
            padding: 9px 12px;
            background: #2563eb;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            margin-top: 8px;
        }
        .btn:hover {
            background: #1d4ed8;
        }
        .hint {
            margin-top: 12px;
            font-size: 12px;
            color: #6b7280;
        }
        .back-link {
            display: inline-block;
            margin-top: 10px;
            font-size: 12px;
            color: #2563eb;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>系统登录</h1>
    <p class="subtitle">用于演示 Iteration 1 的认证与角色识别。</p>

    <%
        String error = (String) request.getAttribute("error");
        String registered = request.getParameter("registered");
        String errorParam = request.getParameter("error");
    %>
    <% if (error != null) { %>
    <div style="background:#fee2e2;color:#991b1b;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
        <%= error %>
    </div>
    <% } else if ("1".equals(registered)) { %>
    <div style="background:#dcfce7;color:#166534;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
        注册成功，请登录。
    </div>
    <% } else if ("1".equals(errorParam)) { %>
    <div style="background:#fee2e2;color:#991b1b;padding:10px;border-radius:10px;font-size:13px;margin-bottom:14px;">
        登录失败，请重试。
    </div>
    <% } %>

    <form action="auth/login" method="post">
        <div class="field">
            <label for="username">用户名</label>
            <input id="username" name="username" type="text" required>
        </div>
        <div class="field">
            <label for="password">密码</label>
            <input id="password" name="password" type="password" required>
        </div>
        <button type="submit" class="btn">登录</button>
    </form>

    <p class="hint">
        后续可以根据登录结果跳转到不同角色的首页：<br>
        TA → 申请岗位视图；MO → 岗位发布视图；Admin → 工作量总览视图。
    </p>

    <a href="register.jsp" class="back-link">还没有账号？去创建档案</a>
    <a href="index.jsp" class="back-link">返回 Iteration 1 总览</a>
</div>
</body>
</html>

