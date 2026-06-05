# 贡献指南

感谢你对本项目的兴趣！欢迎通过以下方式贡献：

## 如何贡献

### 1. 提交问题或建议
发现文档错误、过时信息或有改进想法？请直接 [创建 Issue](../../issues/new)。

### 2. 添加新的示例 Skill
在 `examples/` 目录下创建新的子目录。每个示例 Skill 必须包含：

```
examples/{skill-name}/
├── SKILL.md          # 必须符合 Agent Skills 标准规范
├── scripts/          # (可选) 包含可执行脚本
└── references/       # (可选) 包含参考文档
```

**质量要求**：
- `name` 字段必须与目录名完全一致
- `description` 字段必须清晰描述触发条件（参见 README 中的描述写法原则）
- SKILL.md 正文使用中文，但技术术语可保留英文
- 确保示例具有实际可用性，不只是演示占位符

### 3. 更新文档
直接编辑 `README.md` 并提交 PR。请确保：
- 保持中文为主、关键术语双语的风格
- 更新目录（如添加新章节）
- 外部链接指向可访问的页面

## 提交规范

使用约定式提交 (Conventional Commits)：
```
docs: 更新安装说明
feat(examples): 添加 docker-deployer 示例 Skill
fix: 修正 Cursor 路径描述错误
```

## 行为准则

请保持友善和尊重。本项目欢迎所有水平的贡献者。
