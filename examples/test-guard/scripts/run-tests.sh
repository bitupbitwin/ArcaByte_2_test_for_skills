#!/usr/bin/env bash
# 自动检测项目类型并运行对应测试命令

set -e

if [ -f "pytest.ini" ] || ([ -f "pyproject.toml" ] && grep -q "pytest" pyproject.toml); then
    echo "🐍 检测到 Python 项目，运行 pytest..."
    pytest --tb=short -v
elif [ -f "package.json" ]; then
    echo "📦 检测到 Node.js 项目，运行 npm test..."
    npm test
elif ls ./*_test.go 2>/dev/null | head -1 > /dev/null; then
    echo "🐹 检测到 Go 项目，运行 go test..."
    go test ./...
elif [ -f "pubspec.yaml" ]; then
    echo "🐦 检测到 Flutter 项目，运行 flutter test..."
    flutter test --coverage
elif [ -f "pom.xml" ]; then
    echo "☕ 检测到 Maven 项目，运行 mvn test..."
    mvn test
else
    echo "❌ 无法自动检测项目类型，请手动指定测试命令。"
    exit 1
fi
