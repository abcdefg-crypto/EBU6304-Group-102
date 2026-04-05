<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>TA Recruitment System - Iteration 1 Demo Overview</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            background: #f4f7fb;
            color: #1f2937;
        }

        header {
            background: linear-gradient(135deg, #1f3c88, #2d5bd1);
            color: #fff;
            padding: 20px 32px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.12);
        }

        header h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
            text-align: center;
        }

        .subtitle-part {
            font-size: 16px;
            font-weight: 600;
        }

        main {
            max-width: 1100px;
            margin: 36px auto;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
            padding: 32px 36px 36px;
        }

        .hero {
            margin-bottom: 28px;
        }

        .hero h2 {
            margin: 0 0 12px;
            color: #111827;
            font-size: 20px;
        }

        .hero p {
            margin: 0;
            font-size: 14px;
            color: #4b5563;
            line-height: 1.8;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
            margin-top: 24px;
        }

        .card {
            border-radius: 16px;
            border: 1px solid #dbe4f0;
            padding: 22px 22px 20px;
            background: #f9fbff;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.04);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
        }

        .card h3 {
            margin: 10px 0 10px;
            font-size: 18px;
            color: #111827;
        }

        .card p {
            margin: 0 0 6px;
            font-size: 13px;
            color: #4b5563;
        }

        .tag {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            background: #e6efff;
            color: #1d4ed8;
            margin-bottom: 6px;
        }

        ul {
            margin: 10px 0 0 18px;
            padding: 0;
        }

        li {
            font-size: 14px;
            color: #4b5563;
            margin-bottom: 6px;
            line-height: 1.6;
        }

        .actions {
            margin-top: 32px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
        }

        .btn {
            border-radius: 999px;
            padding: 10px 20px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.22);
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-outline {
            background: #fff;
            color: #2563eb;
            border: 1px solid #cbd5f5;
        }

        .btn-outline:hover {
            background: #eff6ff;
        }

        footer {
            text-align: center;
            font-size: 12px;
            color: #9ca3af;
            margin-top: 28px;
        }

        code {
            background: #eef2ff;
            padding: 2px 6px;
            border-radius: 6px;
            font-size: 12px;
        }

        @media (max-width: 768px) {
            main {
                margin: 20px 16px;
                padding: 24px 20px 28px;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            header h1 {
                font-size: 20px;
            }

            .subtitle-part {
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
<header>
    <h1>TA Recruitment System <span class="subtitle-part">(Iteration 1 Demo Overview)</span></h1>
</header>

<main>
    <section class="hero">
        <h2>迭代 1 范围（核心功能 + 登录模块）</h2>
        <p>
            本页面用于展示 Iteration 1 已实现的核心功能模块，包括登录与角色识别、申请者档案管理、岗位浏览与申请，以及基于 JSON 文件的数据持久化。
        </p>
    </section>

    <section>
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
            <a href="login.jsp" class="btn btn-primary">进入登录流程</a>
            <a href="register.jsp" class="btn btn-outline">创建账号与档案</a>
        </div>
    </section>

    <footer>
        EBU6304 Group Project · Iteration 1 Demo Page
    </footer>
</main>
</body>
</html>