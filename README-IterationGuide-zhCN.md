# EBU6304 助教招聘系统（Iteration 跟进）


> 说明：本项目是 **Maven + Java Web（Servlet/JSP）**，数据采用 **文件持久化（JSON/文本）**，禁止使用数据库。

---

## 1. 项目做什么

系统：**International School Teaching Assistant Recruitment System**

核心价值：替代传统 Excel/表单流程，让 TA（申请者）和 MO（课程负责人）通过系统完成助教招聘的关键步骤。

敏捷交付：项目按 iteration（sprint）递增实现。

迭代 1（本轮目标）的范围在已有 README 中描述为：**Core + Login**，并覆盖与之强相关的最小业务交互（TA/MO 登录后能浏览/发布/申请，并能看到 CV 文件）。

---

## 2. 技术栈与硬约束

1. **Java 17？（我这里是23）**
2. **Maven 构建**，打包类型：`war`
3. **Servlet/JSP**（非 Spring Boot）
4. **数据存储：只能用纯文本/JSON/CSV 等文件**（本项目当前使用 JSON）
5. 代码分层（推荐做法）：
   - `controller`：只做输入输出、页面跳转、参数获取
   - `service`：业务逻辑
   - `repository`：数据读写（本项目通过文件实现）
   - `model`：POJO/数据对象
   - `util`：文件工具、ID 生成等

---

## 3. 代码结构（快速定位你要改哪里）

### 3.1 包结构（以 `src/main/java/com/bupt/is/` 为根）

- `controller/`
  - `AuthController`：`/auth/select-role`、`/auth/login`、`/auth/logout`
  - `UserController`：`/user/register`、`/user/profile`、`/user/cv/upload`、`/user/cv/delete`
  - `JobController`：`/jobs`、`/jobs/detail`、`/jobs/post`、`/jobs/applicants`、`/jobs/applicant-detail`
  - `ApplicationController`：TA 在岗位详情页提交申请（`/applications/apply`）
  - `CvDownloadController`：`/files/cv?cvPath=...` 读取 PDF
- `service/`
  - `AuthService`、`JobService`、`ApplicationService`、`UserService` 等接口
  - `impl/` 里有对应实现：`AuthServiceImpl`、`UserServiceImpl`、`JobServiceImpl`、`ApplicationServiceImpl`
- `repository/`
  - `UserRepository`、`JobRepository`、`ApplicationRepository` 等接口
  - `repository/impl/` 里有文件存储实现：`FileUserRepository`、`FileJobRepository`、`FileApplicationRepository`
- `util/`
  - `FileService`：文件读写（自动创建 `./data` 目录）
  - `IdGenerator`：生成 `USER_*/JOB_*/APP_*` 形式 ID
- `model/`
  - `User`、`Job`、`Application`
  - `ApplicantProfile`：存储用户档案信息（封装进 `User.profile` 的 JSON）
  - `ApplicantCV`：岗位详情页向 JSP 展示用的视图结构

---

## 4. 如何运行项目（推荐：本地 Tomcat + IDEA）

### 4.1 准备环境

- JDK：建议安装并确保 `JAVA_HOME` 指向 JDK 目录（项目要求 Java 17）
- Tomcat：建议 **Tomcat 10.x**（与你的 `jakarta.servlet-api:6.0.0` 匹配）

### 4.2 IDEA 运行方式（最省事，ai说的这个，但我觉得本地tomcat直接移动文件最方便，可以打包问一下ai根据ide环境看看怎么运行最方便）

1. 在 IDEA 中 `Open` 你的 Maven 项目（`pom.xml` 所在目录）
2. 配置 Tomcat：
   - Run → Edit Configurations → `+` → Tomcat Server → Local
   - Application server：选择你解压的 Tomcat 目录
3. Deployment（部署）：
   - 选择该模块生成的 `war exploded`（IDEA 通常会有类似选项）
   - 建议 context path：`/ta-system`（与你 `pom.xml` 的 `finalName: ta-system` 语义一致；如果你不确定，先按 IDEA 给你的 context path 访问）
4. 运行 Tomcat
5. 访问：
   - 应用根路径会自动打开 `index.jsp`（welcome-file）
   - 首页入口：`http://localhost:8080/<context>/`（例如：`/ta-system/`）

---

## 5. Iteration1 端到端使用指南（怎么演示给别人看）

下面这套流程，目标是让你在浏览器里“跑通交互链路”，对应后续答辩展示所需的基本状态。

### 5.1 URL 总览（你可以把它当作流程地图）

- 首页：`/`
- 角色选择页：`/role_select.jsp`（或 `/auth/select-role?role=TA|MO|ADMIN`）
- 登录页：`/login.jsp`（需先选择角色）
- 创建账号/档案：`/register.jsp`
- 登录后查看/编辑档案 & 上传 CV：`/user/profile`、`/user/cv/upload`
- 岗位页（按角色显示不同首页卡片）：`/jobs`
- 岗位详情（TA 申请 / MO 查看申请者简历）：`/jobs/detail?jobId=...`
- MO 发布岗位：`/jobs/post`
- MO 申请者列表：`/jobs/applicants?jobId=...`
- MO 申请者详情：`/jobs/applicant-detail?jobId=...&applicantId=...`
- 下载/预览 CV：`/files/cv?cvPath=...`
- 退出：`/auth/logout`

### 5.2 第一步：注册 TA 与 MO（系统目前没有“默认账号”）

1. 打开：`/register.jsp`
2. 创建一个 **TA** 用户：
   - 角色选择：`TA`
   - 填写：用户名、密码、邮箱、姓名、学号
3. 打开角色选择页后选择身份（如 TA），再到登录页登录：`/role_select.jsp` -> `/login.jsp`
4. 再注册一个 **MO** 用户：
   - 角色选择：`MO`
   - 同样填：用户名、密码、邮箱、姓名、学号

> 登录是否成功取决于账号密码与角色是否匹配。系统会校验“所选登录角色”与用户角色一致（不存在默认用户名/密码）。

### 5.3 第二步：TA 上传 CV（覆盖 Story3/4/5）

TA 登录后进入：`/user/profile`

你可以看到两个核心功能块：

1. 档案信息保存（邮箱/姓名/学号）
2. CV 上传：
   - 表单仅接受 PDF（前端 input + 后端校验 `.pdf`）
   - 上传成功后页面会提示“CV 上传成功”

上传文件实际落地位置（运行时自动创建）：

- `./data/cv/<userId>.pdf`

### 5.4 第三步：MO 发布岗位（覆盖 Story13 的最小交互）

MO 登录后进入：`/jobs/post`

填写：

- 标题（title）
- 课程/模块（module）
- 必需技能（requiredSkills）：用逗号分隔，例如 `Java, 数据结构, 网络协议`
- 最大人数（maxApplicants）
- 岗位描述（description）

提交后回到岗位列表页面 ` /jobs `，此时会出现新发布的 `OPEN` 岗位。

### 5.5 第四步：TA 查看岗位并申请（覆盖 Story6 / Story8 / Story12）

TA 登录后在 ` /jobs ` 主页点击“搜索岗位”进入岗位搜索页（含搜索框+岗位卡片）：

1. 点击“查看详情”进入：`/jobs/detail?jobId=...`
2. 若岗位状态为 `OPEN`，页面会显示“申请该岗位（Story8）”
3. 点击后提交申请（后端会做“重复申请校验”与“CV 必须存在”的校验）

申请成功后会进入“我的申请”列表并显示提交结果。

### 5.6 第五步：MO 管理申请者（查看详情 + 录用/拒绝）

MO 在 ` /jobs ` 主页点击“管理申请者”，进入岗位卡片列表后点击“管理申请者”：

- 申请者列表页：`/jobs/applicants?jobId=...`（含 Detail / Accept / Reject）
- 点击 Detail 进入：`/jobs/applicant-detail?...`，可查看申请者详细资料与简历
- Reject 需要填写原因；原因会同步显示在 TA 的“我的申请”页面

---

## 6. 数据怎么存（你后续调试/验收会用到）

本项目在运行时把数据写到应用根目录下的 `./data/` 文件夹。

目前使用的文件包括：

- `data/users.json`：用户与角色、档案(profile)、CV 路径(cvPath)等
- `data/jobs.json`：岗位信息（状态 OPEN/CLOSED、必需技能列表等）
- `data/applications.json`：申请信息（appId、jobId、applicantId、status、cvPath 等）
- `data/cv/`：PDF 文件落地目录（`<userId>.pdf`）

> 如果 `data/` 目录不存在：运行时会自动创建；但文件内容只在你执行注册/发布/申请后才会出现。

---

## 7. 当前迭代实现现状（用于跟进进度）

根据你们已有 README 的 Product Backlog 表（迭代号为 1 的 story）：

- 目前已经能完成的交互（最小可演示链路）：
  - Story1/2：登录与角色识别（TA/MO 跳转逻辑已具备）
  - Story3/4：申请者档案创建与编辑（在注册/档案页实现）
  - Story5：TA 上传 CV（PDF） + MO 能在岗位详情看到申请者简历链接
  - Story6：TA 查看可用岗位列表
  - Story8：TA 对岗位提交申请（包含重复申请检查）
  - Story12：岗位详情页（TA 申请、MO 查看申请者）
  - Story13：MO 发布岗位（创建 OPEN 岗位）
  - Story26：申请数据以 `applications.json` 形式持久化

- 仍可能缺口（建议你后续对照验收表逐项确认）：
  - Admin 的三卡片入口（Workload Overview / All Applications / Workload Reports）目前是 UI 入口，占位为主，未全部接入完整业务页面
  - Workload 相关统计与分配公平逻辑仍待完善

如果你要继续推进 iteration2/3，我建议你把“缺口对应的 story acceptance criteria”逐条落到具体页面/接口上，然后我们再补齐。

---

## 8. 后续迭代怎么加功能（开发流程模板）

当你要实现下一条 story 时，可以按这个顺序组织代码改动（便于团队协作）：

1. `model/`：如果需要新数据结构，先加 POJO（例如新表单字段）
2. `service/`：在 ServiceImpl 做业务校验与规则（比如“禁止重复申请”“岗位状态必须 OPEN”等）
3. `repository/`：如果需要读写新数据，扩展 FileRepository 或新增 File*Repository
4. `controller/`：增加 Servlet 路由与参数解析，把 request/session 的值传给 service
5. `webapp/`：增加或修改 JSP 页面（表单、列表、详情、错误提示）

原则：**Controller 不写业务逻辑、File IO 不塞进业务逻辑里**。

---

## 9. 常见问题排查

1. **Tomcat 启动失败**：常见是 `JAVA_HOME` 未设置或指向错误 JDK。
2. **浏览器 404**：多半是 `context path` 配错（IDEA 配置的 application context 不同），或 URL 没跟 controller 的 `@WebServlet(urlPatterns=...)` 对上。
3. **登录一直失败**：确认你注册时的用户名/密码是否与输入一致；系统没有默认账号。
4. **TA 申请时报错**：通常是你还没上传 CV（`cvPath` 为空），或岗位不是 `OPEN`。
5. **上传只支持 PDF**：只接受 `.pdf`，并会保存到 `./data/cv/`。

---


