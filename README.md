# 校园主教（TA）招聘系统 — README


## 主要特性（当前框架）

* 基本实体：`User`（及子类 `Applicant`、`ModuleOrganiser`、`Admin`）、`JobPosting`、`Application`、`Assignment`、`Skill` 等。
* 分层架构：`dao`（持久化）、`service`（业务逻辑）、`web`（Servlet 控制器）、`fx`（JavaFX 客户端）。
* 文本持久化：每个实体对应 `*.jsonl`（每行一个 JSON 对象），便于备份和人工检查。
* 自实现 JSON 工具：`cn.univ.recruit.util.JsonUtil`，不依赖 `org.json`/Gson/Jackson，支持 POJO、Map、List、数组、基本类型、Date（ISO-8601）等。
* 简易会话管理：`SessionManager`（内存 session map，示范用途）。
* 匹配/分配模块骨架：`MatchingService`、`AssignmentService` 提供自动/人工分配接口位置。

---

## 代码组织（包结构）

```
cn.univ.recruit
├─ model           // POJO 实体
├─ dao             // 持久化接口与 TextFileStore 实现骨架
├─ service         // 业务逻辑（匹配、申请、分配、验证等）
├─ web             // Servlet（REST-like API）
├─ fx              // JavaFX 前端控制器与入口
├─ auth            // 会话管理
├─ util            // 工具类（包含 JsonUtil、IdUtil）
└─ exception       // 自定义异常
```

---

## 关键类与职责（简要）

* `User` / `Applicant` / `ModuleOrganiser` / `Admin`：用户与角色模型。
* `JobPosting`：岗位/课程助教岗位描述与技能要求。
* `Application`：申请记录（含 `matchScore` 字段）。
* `Assignment`：分配记录（用于工作量统计）。
* `TextFileStore`：文件读写低级封装（同步写、覆盖写）。
* `AuthService`：登录/注册/会话创建。
* `MatchingService`：计算匹配分数（骨架，建议实现加权算法）。
* `JsonUtil`：自写的 JSON 序列化/反序列化工具（见下文详细说明）。

---

## `JsonUtil` 简要说明（位置）

路径：`dev.util.JsonUtil`

功能摘要：

* `toJson(Object obj)`：把任意支持类型（POJO/Map/Collection/数组/Date/Enum/基本类型）序列化为 JSON 字符串。
* `fromJson(String json, Class<T> clazz)`：把 JSON 字符串解析为目标类型对象（支持 Map/List/POJO/数组/基础类型/Enum/Date）。
* 日期格式：`yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`（UTC）。
* 反序列化要求：POJO 需有无参构造器，字段名与 JSON key 对应；字段是私有也能通过反射写入。
* 限制：不处理复杂泛型的完全恢复（常见限制），序列化时对循环引用采取简单策略（已访问对象输出 `null`）。

> 注意：该工具为轻量实现，适用于本项目的 JSON-lines 文本持久化场景。若项目后期对性能或功能有更高要求，建议采用成熟库（Gson 或 Jackson）。

---

## 数据文件布局（建议）

在项目运行目录创建 `data/`：

```
data/
  users.jsonl         # 每行一个 User JSON
  job_postings.jsonl  # 每行一个 JobPosting JSON
  applications.jsonl  # 每行一个 Application JSON
  assignments.jsonl   # 每行一个 Assignment JSON
```

实现注意：

* 写入操作请使用 DAO 层的同步机制（`synchronized` 或 `ReentrantLock`），避免并发写损坏。
* 写入前建议把旧文件备份到 `.bak`。

---

## 后端 API（示例 /api 路径设计 示意）

> 实际方法在 `web` 包对应 Servlet 中实现（骨架已给出）

* `POST /api/auth/login` — 请求体：`{ "username":"", "password":"" }`
* `POST /api/auth/logout`
* `POST /api/auth/register` — 注册申请者
* `GET  /api/job/list`
* `GET  /api/job/{id}`
* `POST /api/job/create`
* `POST /api/application/apply` — 申请岗位
* `POST /api/admin/autoAssign?jobId={id}` — 管理员触发自动分配
* 返回格式建议统一：`{ "success": true|false, "data": ..., "error": { "code": "...", "message": "...", "fields": {...}} }`

---

## 后续开发建议（优先级）

1. 完成 DAO 的 JSON-lines 实现（带文件锁与备份）。
2. 实现 `AuthService` 的安全哈希与会话过期策略。
3. 实现 `MatchingService` 的匹配算法（并编写单元测试）。
4. 完善 Servlet 的 API 响应格式与权限校验。
5. 实现 JavaFX 核心页面（登录、岗位列表、申请、管理面板）。
6. 增加日志（建议使用 slf4j），以及异常监控/友好提示。


