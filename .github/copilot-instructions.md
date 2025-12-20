# 皮蛋工作室代码库指南

> **完整文档**：参见 [docs/PLUGIN_ARCHITECTURE.md](../docs/PLUGIN_ARCHITECTURE.md) 和 [docs/LOCALE_STRUCTURE.md](../docs/LOCALE_STRUCTURE.md)

## 项目概述

Jekyll + GitHub Pages 网站，采用 **Jekyll 插件多语言生成**架构。

- 双语内容（英文/中文）、HTML5 游戏展示、博客系统
- 使用 Jekyll 插件在构建时自动生成多语言页面到 `_site/en/` 和 `_site/zh/`
- 推送 `main` 分支时通过 GitHub Actions 自动部署

## 快速开始

```bash
# 首次安装
bundle install

# 本地开发（插件自动生成页面）
.\build.ps1 dev
# 访问 http://localhost:4000

# 构建产品版本
.\build.ps1 build
```

## 核心架构

| 组件 | 说明 |
|------|------|
| `_templates/` | 页面模板（HTML/MD），含 `ref` front matter |
| `_locale/` | 多语言内容数据（YAML），按类别组织 |
| `_locale/common.yml` | 通用翻译（按钮、消息等） |
| `_locale/includes/*.yml` | 组件翻译（header、footer 等） |
| `_plugins/locale_generator.rb` | Jekyll 插件，在构建时自动生成多语言页面 |
| `_data/games.yml` | 游戏注册表 |
| `_posts/en/` `_posts/zh/` | 博客文章（直接编辑，不通过模板系统） |
| `_site/en/` `_site/zh/` | 自动生成的多语言页面（由插件生成） |

## 常见任务

### 添加新游戏
1. 创建 `/games/game-id/` 目录，放入 Defold 导出文件
2. 在 `_data/games.yml` 添加条目（`id` 需匹配目录名）
3. 推送到 `main` 分支

### 创建/修改页面
1. 创建 `_templates/category/index.html`（含 front matter：`ref: category`、`layout: default`）
2. 创建 `_locale/category/index.yml`（多语言内容）
3. 运行 `.\build.ps1 dev` 或 `.\build.ps1 build`（插件自动生成页面）

### 创建博客文章
在 `_posts/en/YYYY-MM-DD-slug.md` 或 `_posts/zh/` 创建，使用相同 `ref` 值实现双语链接。

## 关键规则

- **模板中翻译**：所有翻译统一使用 `{{ page.translations.key }}`（包括页面、组件、通用翻译）
- **URL 构建**：始终包含语言段：`/{{ page.lang }}/games/`
- **生成目录**：`_site/en/` 和 `_site/zh/` 由插件自动生成，勿手动编辑
- **游戏元数据**：所有字段必需，含 `id`、`title`、`description`、`path`、`thumbnail`、`release_date`、`tags`、`featured`
- **无临时目录**：不再需要手动创建 `/en` 和 `/zh` 目录，插件直接生成到 `_site`

## 故障排除

| 问题 | 解决方案 |
|------|--------|
| 翻译页面未生成 | 检查 front matter 的 `ref` 值，确保 `_locale/` 有对应文件且包含 `title` 字段 |
| 游戏不显示 | 确认 `games.yml` 的 `id` 与目录名匹配 |
| 插件未运行 | 确保未使用 `github-pages` gem（使用自定义构建流程） |
| 本地构建失败 | 运行 `bundle install`；检查 Ruby 版本兼容性；确保所有依赖已安装 |

格式：`<类型>: <描述>`（如 `feat: 添加新游戏`、`fix: 修复导航链接`）



