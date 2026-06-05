# Agent Skills 详尽使用与开发指南 🚀

本仓库是关于 **AI Agent Skills（智能体技能）** 的详细说明与使用指南，旨在帮助开发者深入理解 Skills 的概念、获取与安装方式、核心工作机制，以及在 CLI、IDE（如 Claude Codex、Cursor）和自主 Agent 中的具体实践。

---

## 📖 目录
1. [什么是 Agent Skills？](#-什么是-agent-skills)
2. [Skills 与 MCP (Model Context Protocol) 的区别](#-skills-与-mcp-model-context-protocol-的区别)
3. [如何获取 Skills](#-如何获取-skills)
4. [如何安装 Skills](#-如何安装-skills)
5. [如何开发自定义 Skill](#-如何开发自定义-skill)
6. [如何在各大客户端与 Agent 中使用](#-如何在各大客户端与-agent-中使用)
7. [典型应用场景](#-典型应用场景)
8. [社区资源与前沿动态](#-社区资源与前沿动态)

---

## 🧠 什么是 Agent Skills？

在 AI Agent 领域，**Skills** 是由 **[agentskills.io](https://agentskills.io)** 提出的一个开源、跨平台的开放标准。它是一种**模块化、可复用**的指令与执行包，专门用来扩展 AI 智能体的专业能力。

> [!NOTE]
> 简而言之，一般的 Prompt 就像是口头吩咐，容易被 AI 遗忘且浪费上下文；而 **Agent Skill** 就像是给 AI 准备的一本**“标准作业程序 (SOP) 手册”**。它不仅包含详细的 Markdown 执行规范，还可以绑定配套的可执行脚本（Scripts）和参考文档（References）。

### 核心设计哲学：渐进式加载 (Progressive Disclosure)
为了防止上下文窗口被不相关的指令撑爆（避免 Token 浪费与性能下降），Skills 采用三阶段按需加载：
1. **发现阶段 (Discovery)**：Agent 启动时仅读取 Skills 的 `name` 和 `description`（通常仅消耗 30~50 Token）。
2. **激活阶段 (Activation)**：当用户输入的任务与 Skill 的描述契合时，Agent 自动将对应的 `SKILL.md` 详细指令载入上下文。
3. **执行阶段 (Execution)**：当执行具体任务需要时，Agent 才会按需运行 `scripts/` 中的代码或读取 `references/` 中的辅助文档。

---

## 🔄 Skills 与 MCP (Model Context Protocol) 的区别

很多开发者容易混淆 **Skills** 与 **MCP**，它们其实是相辅相成的两个维度：

| 维度 | Model Context Protocol (MCP) | Agent Skills |
| :--- | :--- | :--- |
| **定位** | **数据与连接通道**（如 USB 接口 / 基础设施） | **业务逻辑与 SOP**（如配方 / 作业规范） |
| **主要功能** | 提供通用的协议标准，用于将 AI 连接到数据库、API、本地文件系统等外部工具。 | 告诉 AI 应该“如何”去组合这些工具，以特定的步骤和策略完成一项复杂的业务目标。 |
| **例子** | **MCP Tool**: `query_postgres_db` (查询数据库工具) | **Skill**: `database-performance-tuning` (指导 Agent 如何抓取慢查询、分析执行计划、生成索引优化建议的 SOP 流程) |

---

## 🔍 如何获取 Skills

目前获取 Agent Skills 主要有以下几种方式：

1. **社区开源仓库**：
   - 访问 **[agentskills.io](https://agentskills.io)** 官方平台。
   - GitHub 上的 Awesome 列表（如搜索 `awesome-claude-skills` 或 `antigravity-awesome-skills`）。
2. **企业内部分享**：
   - 团队内部针对特定的项目规范、DevOps 流程开发的专有 Skills 文件夹，放在 Git 仓库中随项目分发。
3. **利用 AI 自动生成**：
   - 许多客户端（如 Claude Code）内置了 `/skill-creator` 工具，开发者只需口头描述工作流程，AI 就会自动在本地生成符合规范的 Skill 文件夹。

---

## ⚙️ 如何安装 Skills

安装 Skills 本质上是将其文件夹放置在 Agent 能够识别的特定目录下。Skills 分为**项目级（局部）**和**用户级（全局）**两种：

### 1. 项目级安装 (Project-specific)
只对当前工作区或项目生效，非常适合团队协作和项目专属规范。
*   **Antigravity / Cursor** 路径：`[Your-Project-Root]/.agents/skills/{skill-name}/`
*   **Claude Code** 路径：`[Your-Project-Root]/.claude/skills/{skill-name}/`

### 2. 全局安装 (Global)
对当前用户的所有项目和终端会话都生效，适合存放个人习惯的通用工具箱。
*   **Antigravity CLI** 路径：`~/.gemini/antigravity-cli/skills/{skill-name}/` 或 `~/.gemini/config/skills/{skill-name}/`
*   **Claude Code CLI** 路径：`~/.claude/skills/{skill-name}/`

> [!TIP]
> 安装过程非常简单：只需要将技能文件夹（如 `code-reviewer/`）直接复制或克隆到上述对应目录即可。重新启动 CLI 或刷新工作区，Agent 就会自动识别。

---

## 🛠️ 如何开发自定义 Skill

一个标准的 Agent Skill 文件夹目录结构如下：

```text
my-custom-skill/            # 文件夹名称必须与 Frontmatter 中的 name 一致
├── SKILL.md                # 必选：技能核心定义文件（Markdown + YAML Frontmatter）
├── scripts/                # 可选：存放 Agent 可调用的自动化执行脚本（Python、Bash 等）
├── references/             # 可选：存放参考文档、企业规范文档等
└── assets/                 # 可选：存放静态资源、模版、图片等
```

### 1. 编写 `SKILL.md`

`SKILL.md` 的顶部必须包含 **YAML Frontmatter**，用于向 Agent 声明元数据，以下是一个完整的标准模板：

```yaml
---
name: flutter-test-runner
description: 用于自动运行 Flutter 单元测试、分析测试覆盖率并自动修复测试报错。在用户要求运行测试或修复测试相关代码时触发。
license: MIT
compatibility: Requires flutter, dart
metadata:
  author: dev-team
  version: 1.0.0
allowed-tools:
  - run_command
  - write_file
  - replace_file_content
---

# Flutter 测试与修复指南

你现在的角色是一个高级 Flutter 测试专家。当此技能被激活时，请严格遵守以下步骤：

## 1. 运行测试
优先执行命令：
`flutter test --coverage`

## 2. 报错处理
如果测试失败，请读取 `coverage/` 下的报告，并定位失败的代码：
- 检查 Mock 数据是否未正确配置。
- 使用 `replace_file_content` 修复逻辑错误。
- 重新运行测试直至全部通过。
```

> [!IMPORTANT]
> - **`name` 限制**：最大 64 字符，只能包含小写字母、数字和连字符 `-`，且文件夹名必须与该属性完全一致。
> - **`description` 限制**：最大 1024 字符，描述必须极其精准，这是 Agent 判定是否自动加载该 Skill 的唯一依据。
> - **`allowed-tools` 限制**：声明该 Skill 允许使用的系统工具，确保安全性。

---

## 💻 如何在各大客户端与 Agent 中使用

### 1. 在 CLI 命令行中使用
这是目前 Skills 最原生、最强大的使用场景（如在 Claude Code CLI 或 Antigravity CLI 中）。

*   **查看已安装技能**：
    在命令行提示符中输入：
    ```bash
    /skills
    ```
    Agent 将会列出所有当前全局和当前项目下已启用的 Skills 列表。

*   **强制显式调用**：
    如果你想针对当前任务强制启用某个技能，可以使用斜杠命令：
    ```bash
    /{skill-name} [你的具体需求]
    # 例如：
    /flutter-test-runner 运行当前项目的测试并修复报错
    ```
    这会绕过描述匹配，直接强制 Agent 将该 `SKILL.md` 内容载入 Context 并开始执行。

*   **隐式自动触发**：
    你不需要输入任何斜杠。正常和 Agent 聊天即可：
    > *"帮我把当前项目的测试跑一下，如果有错的话顺便修了。"*
    
    Agent 会在后台自动检索所有 Skill 的 `description`。如果发现 `flutter-test-runner` 的描述高度匹配，它会自动打印一条提示并加载该技能，无缝应用其中定义的规则。

---

### 2. 在 Claude Codex / Cursor 等 IDE 客户端中使用
在图形化 IDE 编辑器中，Skills 提供了更直观的上下文绑定：

*   **Cursor 引用机制**：
    由于 Cursor 暂未完全原生内置开放的 `/skills` 解析链路，开发者通常通过 **Context Reference** 机制来使用。
    - 在聊天框或 Composer 中，输入 `@` 并选择 `SKILL.md` 文件（如 `@.agents/skills/code-reviewer/SKILL.md`）。
    - 也可以直接将技能的说明作为系统 Prompt 的一部分（在 Cursor 的 System Prompt 设置中引用）。
    
*   **Claude Codex**：
    作为 Anthropic 的先进编程环境，Claude Codex 原生支持项目底部的 `.claude/skills/` 规范。
    - 只要项目根目录包含 `.claude/skills/` 目录，Codex 在扫描工作空间时会自动将这些 Skills 编译进可选项。
    - 在 Codex 聊天界面，你可以直接输入 `/` 触发命令菜单，选择你自定义的 Skills。

---

### 3. 在自主 Agent (Autonomous Agents) 中使用
如 OpenHands、PraisonAI 或 LangGraph 构建的 Agent 团队：

*   **多智能体角色分配**：
    在多智能体框架中，Skills 可以作为“资产”分配给特定的 Agent 节点。例如，你可以定义一个 `security-audit` 技能文件夹，并在代码中初始化：
    ```python
    from praisonai import Agent
    
    # 框架将自动读取 SKILL.md 并将其注入该 Agent 的 System Prompt
    security_agent = Agent(
        name="Security Expert",
        skill_path="./skills/security-audit"
    )
    ```

---

## 🎯 典型应用场景

*   **代码风格规范共建 (Code Guard)**：
    团队制定的 Java/C/TypeScript 代码规范极其繁杂，新人容易犯错。通过建立 `code-reviewer` 技能，让 Agent 在提提交前自动扫描并修改不符合命名、分层设计的代码。
*   **复杂环境部署 (Smart Deployer)**：
    部署一个微服务需要运行 5 个不同的 CLI 命令并修改 Kubernetes 配置。创建 `service-deploy` 技能，配合 `scripts/deploy.sh`，让 Agent 代理整个部署与健康检查流程。
*   **单元测试自动化 (Test Guard)**：
    每次修改代码后自动运行测试，读取测试失败日志，自我反思，修复 Bug，直到测试 100% 通过再交付。
*   **文档同步更新 (Doc Sync)**：
    在修改任何核心 API 或数据库 Schema 后，自动检测并更新对应的 OpenAPI / Markdown 文档，防止文档过期。

---

## 🌐 社区资源与前沿动态

*   **官方网站**: [agentskills.io](https://agentskills.io) —— 获取最新的标准协议规范与官方工具链。
*   **协议开源库**: [GitHub - agentskills/agentskills](https://github.com/agentskills/agentskills) —— 参与开源标准制定，提交你的通用 Skill。
*   **Antigravity 官方**: [antigravity.google](https://antigravity.google) —— 查看 Google Agentic 开发工具与 CLI 的最新演进。