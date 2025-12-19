# 皮蛋工作室代码库指南

> **完整文档**：参见 [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) 和 [docs/LOCALE_STRUCTURE.md](../docs/LOCALE_STRUCTURE.md)

## 项目概述

Jekyll + GitHub Pages 网站，采用**模板 + 语言环境文件（Locale）**架构。

- 双语内容（英文/中文）、HTML5 游戏展示、博客系统
- 自动生成多语言页面到 `/en/` 和 `/zh/` 目录
- 推送 `main` 分支时自动部署

## 快速开始

```bash
# 首次安装
bundle install

# 本地开发（监视模板变化）
.\build.ps1 dev
# 访问 http://localhost:4000

# 生成页面
.\build.ps1 generate

# 构建产品版本
.\build.ps1 build
```

## 核心架构

| 组件 | 说明 |
|------|------|
| `_templates/` | 页面模板（HTML/MD），含 `ref` front matter |
| `_locale/` | 多语言内容数据（YAML），按类别组织 |
| `scripts/generate_pages.rb` | 自动生成多语言页面 |
| `_data/games.yml` | 游戏注册表 |
| `_posts/en/` `_posts/zh/` | 博客文章（直接编辑，不通过模板系统） |

## 常见任务

### 添加新游戏
1. 创建 `/games/game-id/` 目录，放入 Defold 导出文件
2. 在 `_data/games.yml` 添加条目（`id` 需匹配目录名）
3. 推送到 `main` 分支

### 创建/修改页面
1. 创建 `_templates/category/index.html`（含 front matter：`ref: category`、`layout: default`）
2. 创建 `_locale/category/index.yml`（多语言内容）
3. 运行 `.\build.ps1 generate`

### 创建博客文章
在 `_posts/en/YYYY-MM-DD-slug.md` 或 `_posts/zh/` 创建，使用相同 `ref` 值实现双语链接。

## 关键规则

- **模板中翻译**：`{% assign t = site.data.translations[page.lang] %}` 然后 `{{ t.key }}`
- **URL 构建**：始终包含语言段：`/{{ page.lang }}/games/`
- **生成目录**：`/en/` 和 `/zh/` 由脚本自动生成，勿手动编辑（`.\build.ps1 clean` 会删除）
- **游戏元数据**：所有字段必需，含 `id`、`title`、`description`、`path`、`thumbnail`、`release_date`、`tags`、`featured`

## 故障排除

| 问题 | 解决方案 |
|------|--------|
| 翻译页面 404 | 检查 front matter 的 `page.lang` 和 `ref` 值 |
| 游戏不显示 | 确认 `games.yml` 的 `id` 与目录名匹配 |
| 页面未生成 | 确保模板有 `ref` front matter，对应 `_locale/` 文件存在 |
| 本地构建失败 | 运行 `bundle install`；检查 Ruby 版本兼容性 |

## 提交日志规范

格式：`<类型>: <描述>`（如 `feat: 添加新游戏`、`fix: 修复导航链接`）



