<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>TA Recruitment System</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #1d4ed8 0%, #0ea5e9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            width: 380px;
            background: #fff;
            border-radius: 18px;
            padding: 32px 30px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.28);
            text-align: center;
        }
        h1 {
            margin: 0;
            font-size: 24px;
            color: #111827;
        }
        .actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        .btn {
            border-radius: 999px;
            padding: 10px 18px;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            border: none;
            background: #2563eb;
            color: #fff;
        }
        .btn-outline {
            border: 1px solid #cbd5f5;
            background: #fff;
            color: #2563eb;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>TA Recruitment System</h1>
    <div class="actions">
        <a href="<%=request.getContextPath()%>/role_select.jsp" class="btn btn-primary">Login</a>
        <a href="<%=request.getContextPath()%>/register.jsp" class="btn btn-outline">Register</a>
    </div>
</div>
</body>
</html>