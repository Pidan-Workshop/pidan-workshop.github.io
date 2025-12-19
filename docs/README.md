# 文档目录

欢迎来到皮蛋工作室网站项目的文档中心。

## 📚 文档列表

### [ARCHITECTURE.md](./ARCHITECTURE.md)
**单文件多语言架构完整指南**

详细介绍新的模板预生成系统，包括：
- 架构概述和工作原理
- 开发工作流程
- 添加新页面和新语言的步骤
- 故障排除
- 性能说明

**适合**：想要深入了解架构设计和日常开发的开发者


## 🚀 快速开始

如果你是新来的开发者：

1. **阅读主 README**：[../README.md](../README.md)
   - 项目概览
   - 快速安装和运行
   
2. **了解架构**：[ARCHITECTURE.md](./ARCHITECTURE.md)
   - 理解模板系统如何工作
   - 学习开发工作流

3. **开始开发**：
   ```bash
   # 克隆仓库
   git clone https://github.com/Pidan-Workshop/pidan-workshop.github.io.git
   
   # 安装依赖
   bundle install
   
   # 生成页面并启动开发服务器
   make dev
   ```

## 📖 其他文档

### 主目录文档

- [../README.md](../README.md) - 项目主文档
- [../CHANGELOG.md](../CHANGELOG.md) - 版本变更日志
- [../GAME_INTEGRATION.md](../GAME_INTEGRATION.md) - 游戏集成指南

### 提示文件

- [../.github/prompts/plan-singleFileMultilang.prompt.md](../.github/prompts/plan-singleFileMultilang.prompt.md) - 架构重构计划
- [../.github/copilot-instructions.md](../.github/copilot-instructions.md) - Copilot 代码库指南

## 🔧 开发资源

### 脚本
- [../scripts/generate_pages.rb](../scripts/generate_pages.rb) - 页面生成脚本
- [../scripts/watch.rb](../scripts/watch.rb) - 开发监听脚本（可选）

### 配置文件
- [../Makefile](../Makefile) - 开发命令
- [../.github/workflows/pages.yml](../.github/workflows/pages.yml) - CI/CD 配置
- [../.gitignore](../.gitignore) - Git 忽略规则

### 模板和翻译
- `../_templates/` - 页面模板目录
- `../_locale/` - 翻译数据目录
- `../_data/` - Jekyll 数据文件

## 💡 常用命令

```bash
# 生成语言特定页面
make generate
# 或
ruby scripts/generate_pages.rb

# 启动开发服务器
make dev

# 构建生产版本
make build

# 清理生成文件
make clean

# 查看所有可用命令
make help
```

## 🤝 贡献

如果你想改进文档：

1. 在 `docs/` 目录下创建或编辑 Markdown 文件
2. 遵循现有文档的格式和风格
3. 提交 Pull Request

## 📧 联系

- GitHub: [@Pidan-Workshop](https://github.com/Pidan-Workshop)
- Website: [pidanworshop.github.io](https://pidanworshop.github.io)

---

最后更新：2025-12-19
