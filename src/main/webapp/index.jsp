<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>TA Recruitment System - Iteration 1</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            background: #f5f7fb;
        }
        header {
            background: #1f3c88;
            color: #fff;
            padding: 16px 32px;
        }
        header h1 {
            margin: 0;
            font-size: 22px;
        }
        main {
            max-width: 960px;
            margin: 32px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
            padding: 24px 32px 32px;
        }
        h2 {
            margin-top: 0;
            color: #1f2933;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 16px;
            margin-top: 16px;
        }
        .card {
            border-radius: 10px;
            border: 1px solid #e1e5f2;
            padding: 18px 20px;
            background: #fafbff;
        }
        .card h3 {
            margin: 0 0 8px;
            font-size: 16px;
            color: #111827;
        }
        .card p {
            margin: 0 0 6px;
            font-size: 13px;
            color: #4b5563;
        }
        .tag {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 11px;
            background: #e0ecff;
            color: #1d4ed8;
            margin-right: 4px;
        }
        .actions {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .btn {
            border-radius: 999px;
            padding: 8px 16px;
            border: none;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-primary {
            background: #2563eb;
            color: #fff;
        }
        .btn-outline {
            background: #fff;
            color: #2563eb;
            border: 1px solid #cbd5f5;
        }
        footer {
            text-align: center;
            font-size: 12px;
            color: #9ca3af;
            margin-top: 24px;
        }
        ul {
            margin: 8px 0 0 18px;
            padding: 0;
        }
        li {
            font-size: 13px;
            color: #4b5563;
            margin-bottom: 2px;
        }
    </style>
</head>
<body>
<header>
    <h1>TA Recruitment System · Iteration 1 概览</h1>
</header>
<main>
    <section>
        <h2>迭代 1 目标（Core + Login）</h2>
        <p style="font-size: 14px; color: #4b5563;">
            本页面用于直观展示迭代 1 的核心功能范围，对应 Product Backlog 中迭代号为 1 的 User Stories。
        </p>
        <div class="grid">
            <div class="card">
                <span class="tag">认证 & 角色</span>
                <h3>登录与角色识别</h3>
                <ul>
                    <li>Story1: 用户登录</li>
                    <li>Story2: 基于角色的访问控制（TA / MO / Admin）</li>
                </ul>
            </div>
            <div class="card">
                <span class="tag">TA 档案</span>
                <h3>申请者档案与简历</h3>
                <ul>
                    <li>Story3: 创建申请者档案</li>
                    <li>Story4: 编辑申请者档案</li>
                    <li>Story5: 上传 CV（PDF）</li>
                </ul>
            </div>
            <div class="card">
                <span class="tag">岗位</span>
                <h3>岗位浏览与申请</h3>
                <ul>
                    <li>Story6: 查看可用岗位</li>
                    <li>Story8: 申请岗位</li>
                    <li>Story12: 查看岗位详情</li>
                    <li>Story13: MO 发布岗位</li>
                </ul>
            </div>
            <div class="card">
                <span class="tag">数据持久化</span>
                <h3>文本文件存储</h3>
                <ul>
                    <li>Story26: 申请数据以 <code>.json</code> 文本文件持久化</li>
                    <li>文件示例：<code>data/users.json</code>、<code>data/jobs.json</code>、<code>data/applications.json</code></li>
                </ul>
            </div>
        </div>
        <div class="actions">
            <a href="login.jsp" class="btn btn-primary">开始体验登录流程</a>
            <a href="register.jsp" class="btn btn-outline">创建账号/档案（Story3）</a>
        </div>
    </section>
    <footer>
        EBU6304 Group Project · Iteration 1 Demo Page
    </footer>
</main>
</body>
</html>

