# 测试最佳实践参考

## 测试金字塔原则

- **单元测试** (70%)：快速、隔离、覆盖业务逻辑
- **集成测试** (20%)：验证模块间交互
- **端到端测试** (10%)：验证关键用户路径

## 好测试的标准 (FIRST)

- **Fast**：单个测试应在毫秒级完成
- **Independent**：测试间不应有依赖关系
- **Repeatable**：任何环境下结果相同
- **Self-validating**：测试本身判断通过/失败
- **Timely**：与被测代码同步编写

## 命名规范

```python
# ✅ 好的命名：描述场景和期望结果
def test_user_login_with_invalid_password_returns_401():
    ...

# ❌ 差的命名：不知道测试什么
def test_login():
    ...
```

## Mock 使用原则

只 Mock 外部依赖（数据库、HTTP 请求、文件系统），不要 Mock 被测模块内部的私有方法。
