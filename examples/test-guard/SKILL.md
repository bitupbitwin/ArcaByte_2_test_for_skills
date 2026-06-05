---
name: test-guard
description: 当用户要求运行测试、修复测试报错、提高测试覆盖率、确保测试通过、执行 CI 检查时触发。自动运行测试套件并循环修复直到全部通过。
license: MIT
metadata:
  author: arcabyte-team
  version: 1.0.0
allowed-tools:
  - run_command
  - read_file
  - write_file
  - replace_file_content
---

# 测试守护专家

你现在是一位测试自动化专家。当此技能激活时，请执行以下自动化测试与修复循环。

## 执行流程

### 第一步：检测项目类型并运行测试

根据项目文件判断测试框架，然后运行对应命令：

| 项目类型 | 检测文件 | 测试命令 |
|:---|:---|:---|
| Python | `pytest.ini` / `pyproject.toml` | `pytest --tb=short -v` |
| Node.js | `package.json` (jest/vitest) | `npm test` 或 `npx vitest` |
| Go | `*_test.go` | `go test ./...` |
| Flutter/Dart | `pubspec.yaml` | `flutter test --coverage` |
| Java/Maven | `pom.xml` | `mvn test` |

### 第二步：分析失败原因

如果测试失败，按以下顺序排查：
1. 读取完整错误信息，定位失败的测试文件和行号
2. 检查是否为 Mock/Stub 配置问题
3. 检查是否为断言值与实际值不符
4. 检查是否为环境依赖缺失（数据库、外部服务）

### 第三步：自动修复

- 优先修复**实现代码**，而非测试代码（除非测试本身有 bug）
- 每次只修复一个失败点，修复后立即重新运行测试
- 若同一问题修复 3 次仍失败，停止并向用户报告详细原因

### 第四步：覆盖率报告

测试全部通过后，生成覆盖率报告并指出覆盖率低于 80% 的模块。

## 参考资源

详细的测试最佳实践请参阅 [`references/testing-best-practices.md`](./references/testing-best-practices.md)。
