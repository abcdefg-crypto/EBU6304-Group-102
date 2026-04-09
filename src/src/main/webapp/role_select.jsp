<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Select Role - TA Recruitment System</title>
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
            width: 760px;
            background: #fff;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.28);
            text-align: center;
        }
        h1 {
            margin: 0 0 10px;
            font-size: 30px;
            color: #111827;
            letter-spacing: 1px;
        }
        .subtitle {
            margin: 0 0 24px;
            color: #4b5563;
            font-size: 14px;
        }
        .roles {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
        }
        .role-card {
            border: 1px solid #dbe4ff;
            border-radius: 14px;
            padding: 22px 10px;
            text-decoration: none;
            background: #f8fbff;
            color: #111827;
            transition: transform .15s ease, box-shadow .15s ease, border-color .15s ease;
        }
        .role-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.16);
            border-color: #93c5fd;
        }
        .role-card strong {
            display: block;
            font-size: 24px;
            margin-bottom: 8px;
        }
        .role-card span {
            font-size: 13px;
            color: #4b5563;
        }
        .back {
            margin-top: 18px;
            display: inline-block;
            color: #2563eb;
            text-decoration: none;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>WHO ARE U ?</h1>
    <p class="subtitle">Choose your login role. You can only log in with the selected role account.</p>
    <div class="roles">
        <a class="role-card" href="<%=request.getContextPath()%>/auth/select-role?role=TA">
            <strong>I'm Applicant</strong>
            <span>TA / Applicant login</span>
        </a>
        <a class="role-card" href="<%=request.getContextPath()%>/auth/select-role?role=MO">
            <strong>I'm MO</strong>
            <span>Module Owner login</span>
        </a>
        <a class="role-card" href="<%=request.getContextPath()%>/auth/select-role?role=ADMIN">
            <strong>I'm Admin</strong>
            <span>Admin login</span>
        </a>
    </div>
    <a class="back" href="<%=request.getContextPath()%>/index.jsp">Back to Home</a>
</div>
</body>
</html>
