# EBU6304-Group-102
EBU6304 Software Engineering Group Project - BUPT TA Recruitment System

## 项目简介
本项目为北京邮电大学国际学院（BUPT International School）开发的助教（TA）招聘系统。旨在取代传统的 Excel 和纸质表单，实现 TA 申请、职位发布、简历上传及 AI 岗位匹配的自动化流程。

## 架构设计 (Architecture)
本项目采用 **MVC (Model-View-Controller)** 模式，严格遵循 Maven 标准目录规范。

- **Model**: 位于 `com.bupt.is.model`，定义数据实体（如 TA, Job, Application）。
- **View**: 位于 `webapp/WEB-INF/views`，负责 JSP 页面渲染。
- **Controller**: 位于 `com.bupt.is.controller`，由 Servlet 处理业务请求。
- **Persistence**: 位于 `com.bupt.is.util`，通过 `FileHandler` 实现基于 JSON 的本地数据持久化（本项目不使用数据库）。

## 目录结构 (Directory Structure)
```text
src/main/java/com/bupt/is/
├── controller/  # Servlets (处理前端请求)
├── model/       # JavaBeans (实体类)
├── service/     # Business Logic (业务逻辑与 AI 匹配算法)
└── util/        # Helpers (JSON 文件读写工具)

src/main/resources/data/   # 数据存储目录 (存放 .json 文件)

src/main/webapp/
├── WEB-INF/
│   ├── web.xml  # Web 应用配置
│   └── views/   # JSP 文件 (安全隔离区)
└── static/      # 静态资源 (CSS, JS, Images)
