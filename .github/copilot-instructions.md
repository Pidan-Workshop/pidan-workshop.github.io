# 皮蛋工作室代码库指南

## 项目概述

这是一个基于 Jekyll 的 GitHub Pages 网站，为皮蛋工作室提供双语内容（英文/中文）、HTML5 游戏展示、产品展示和博客系统。当推送到 `main` 分支时，网站会自动通过 GitHub Pages 部署。

采用**模板 + 语言环境文件（Locale）**架构，通过构建脚本自动生成多语言页面。

## 提交日志规范
使用结构化的提交信息便于追踪和代码审查。格式为：`<类型>: <描述>`

## 架构与关键概念

### 双语结构（新架构）
- **模板系统**：`_templates/` 目录包含页面模板（`.html` 和 `.md` 文件），包含 front matter 和内容
- **语言环境数据**：`_locale/` 目录包含多语言内容（YAML 格式），按页面类别组织（如 `_locale/about/index.yml`、`_locale/games/index.yml`）
- **自动生成**：`scripts/generate_pages.rb` 脚本将模板与语言数据结合，为每种语言生成对应的页面到 `/en/` 和 `/zh/` 目录
- **生成目录**：`/en/` 和 `/zh/` 目录由构建脚本自动生成，**不应手动编辑**（运行 `.\build.ps1 clean` 时会被删除）
- **语言元数据**：`_data/languages.yml` 定义支持的语言和标志（emoji 格式）
- **页面语言上下文**：生成的页面自动设置 `lang: en` 或 `lang: zh` front matter

### 游戏集成系统
- **游戏存储**：`/games/{game-id}/` 目录包含 Defold HTML5 导出文件（index.html、dmengine.js、archive 文件）
- **元数据注册表**：`_data/games.yml` 定义所有游戏的双语标题、描述和标签
- **特色游戏**：在 games.yml 中设置 `featured: true` 以在首页显示
- **动态显示**：游戏模板遍历 games.yml 并渲染指向 `/games/{game-id}/` 的链接

### 内容组织
- **模板**：`_templates/` 包含页面结构和布局，使用 `ref` front matter 字段关联语言环境文件
- **语言文件**：`_locale/` 包含多语言内容数据（YAML），按类别组织（index/about/blog/games/products）
- **博客文章**：`_posts/en/` 和 `_posts/zh/` 用于博客文章（不通过模板生成系统）
- **生成页面**：`en/` 和 `/zh/` 目录由 `scripts/generate_pages.rb` 自动生成
- **资源**：`assets/css/main.css`、`assets/js/main.js`、`assets/images/games/` 用于样式、脚本和缩略图

## 开发工作流

### 本地测试
```bash
# 安装依赖（首次）
bundle install

# 启动开发服务器并监视模板变化
.\build.ps1 dev
# 访问 http://localhost:4000
```

### 生成输出
- **页面生成**：运行 `.\build.ps1 generate` 从 `_templates/` 和 `_locale/` 生成 `en/` 和 `zh/` 目录
- **Jekyll 构建**：运行 `bundle exec jekyll build` 处理所有文件生成 `_site/`
- **生成的网站**：`_site/` 目录中包含最终的静态 HTML（从版本控制中排除）

### 关键构建命令
- `.\build.ps1 dev`：启动开发服务器并自动监视模板和本地文件变化
- `.\build.ps1 generate`：从模板和语言环境文件生成多语言页面
- `.\build.ps1 serve`：仅启动 Jekyll 服务器（不监视模板）
- `.\build.ps1 build`：生成生产版本的网站
- `.\build.ps1 clean`：清理所有生成的页面目录（`en/`、`zh/`）

## 关键模式与约定

### 1. 翻译访问模式
**正确方法**（在模板文件中）：
```liquid
{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.nav_home }}</h1>
```
**原因**：避免硬编码字符串；实现 UI 文案的单一真实来源。

### 2. 双语内容的 URL 构建
**始终使用 relative_url 过滤器和显式语言段**：
```liquid
<a href="/{{ page.lang }}/games/">{{ t.nav_games }}</a>
<!-- 不要用：/games/ （会破坏语言上下文）-->
```

### 3. 模板系统工作流
添加新的静态页面时：
1. 在 `_templates/category/index.html` 中创建模板文件
2. 在 front matter 中设置 `ref: category` 和 `layout: default`
3. 在 `_locale/category/index.yml` 中创建对应的语言环境文件
4. 在 YAML 中定义多语言内容（格式：`key: { en: "English", zh: "中文" }`）
5. 运行 `.\build.ps1 generate` 自动生成 `en/` 和 `zh/` 目录下的页面

### 4. 游戏元数据格式
添加游戏到 `_data/games.yml` 时，**所有字段都是必需的**：
```yaml
- id: game-name               # 小写，用连字符分隔
  title: { en: "Title", zh: "标题" }
  description: { en: "Desc", zh: "描述" }
  path: "/games/game-name/"
  thumbnail: "/assets/images/games/name.jpg"
  release_date: YYYY-MM-DD
  tags: [genre1, genre2]
  featured: true/false
```
**关键**：`id` 必须与 `/games/` 下的目录名称匹配。

### 5. 博客文章前言
```markdown
---
layout: post
title: "文章标题"
date: YYYY-MM-DD
author: 作者名称
ref: unique-id-across-languages
lang: en
tags: [tag1, tag2]
---
```
**关键**：`ref` 字段在英文和中文版本之间链接；在两个语言版本中使用相同的 `ref` 值。

### 6. 导航和语言切换
- 语言切换器（`_includes/language-switcher.html`）读取 `page.ref` 以找到翻译的对应页面
- 如果没有提供 `ref`，则回退到特定语言的首页（`/{{ lang_code }}/`）
- 标题包括根据 `page.lang` 用翻译的导航标签动态构建

## 资源与文件组织

### 图片
- 游戏缩略图：`assets/images/games/`（推荐：600x400px）
- 在 YAML/模板中通过 `/assets/images/games/filename.jpg` 引用

### CSS/JS
- 在 `assets/css/main.css` 和 `assets/js/main.js` 中缩小
- 通过默认布局全局应用
- 特性：平滑滚动锚点、延迟图像加载、活跃导航突出显示

## 依赖关系与配置

### Gems（来自 Gemfile）
- `jekyll-feed`：生成 RSS 源（在 `_config.yml` 插件中引用）
- `jekyll-seo-tag`：自动生成 SEO 元标签
- `jekyll-sitemap`：创建 sitemap.xml

### Jekyll 配置（_config.yml）
- `url`：https://pidanworshop.github.io（用于绝对 URL 生成）
- `baseurl`：""（空；网站在域根目录）
- `permalink`：/blog/:categories/:year/:month/:day/:title/（文章 URL 格式）
- Collections 排除 Gemfile、README、node_modules

## 常见任务与方法

### 添加新游戏
1. 创建 `/games/new-game-id/` 目录
2. 复制 Defold 导出文件（index.html、dmengine.js、archive 文件）
3. 向 `_data/games.yml` 添加条目，匹配 `id`
4. 提交并推送（GitHub Pages 自动部署）

### 创建或修改静态页面
1. **创建模板**：在 `_templates/category/index.html` 创建页面模板
2. **设置 front matter**：包含 `ref: category` 和 `layout: default`
3. **创建语言文件**：在 `_locale/category/index.yml` 中定义多语言内容
   ```yaml
   title:
     en: "Page Title"
     zh: "页面标题"
   content:
     en: "English content here"
     zh: "中文内容"
   ```
4. **生成页面**：运行 `.\build.ps1 generate`
5. **验证**：检查生成的 `en/category/index.html` 和 `zh/category/index.html`

### 创建博客文章
1. 创建文件：`_posts/en/YYYY-MM-DD-slug.md`（或 zh/ 用于中文）
2. 使用必需的 front matter，包含语言特定的 `title` 和 `lang`
3. 对于翻译：在其他语言目录中创建匹配的文件，使用相同的 `ref`

### 翻译现有页面
1. 在对应语言的 `_locale/` 目录中创建或修改语言文件
2. 确保使用正确的 `ref` 值（模板中的 front matter 字段）
3. 运行 `.\build.ps1 generate` 重新生成页面
4. 验证双语导航切换是否正常工作

## 测试与验证

- **本地预览**：`bundle exec jekyll serve` 生成在 http://localhost:4000
- **手动检查**：验证双语导航切换、游戏加载、博客文章格式
- **部署**：推送到 `main` → GitHub Pages 在几秒内自动构建

## 关键文件参考

| 文件 | 用途 |
|------|------|
| `_config.yml` | Jekyll 设置、插件配置、URL/baseurl |
| `_data/games.yml` | 游戏注册表（标题、描述、路径、缩略图） |
| `_data/translations.yml` | 按语言的 UI 字符串翻译 |
| `_data/languages.yml` | 语言名称和标志 emoji |
| `_templates/` | 页面模板目录（.html 和 .md 文件，包含 ref 和 layout front matter） |
| `_locale/` | 语言环境数据目录（YAML 格式，按类别组织） |
| `scripts/generate_pages.rb` | 从模板和语言文件生成多语言页面的脚本 |
| `build.ps1` | Windows PowerShell 构建脚本（generate/dev/serve/build/clean） |
| `_layouts/default.html` | 主模板（头部、页脚、内容包装） |
| `_includes/language-switcher.html` | 使用 `page.ref` 的双语导航组件 |
| `_includes/header.html` | 具有导航和语言切换器的网站头部 |
| `Gemfile` | Ruby 依赖项 |

## 调试技巧

- **翻译页面上出现 404**：检查 front matter 中是否设置了 `page.lang`；验证语言切换器 `ref` 值在 en/zh 版本之间匹配
- **游戏无法加载**：确认游戏目录与 games.yml 中的 `id` 匹配；验证 index.html 中 dmengine.js 的路径
- **翻译丢失**：检查 `_data/translations.yml` 中的键；确保模板使用 `{{ t.key_name }}`
- **页面未生成**：确保 `_templates/` 中的模板有 `ref` front matter；检查对应的 `_locale/` 文件是否存在；运行 `.\build.ps1 generate`
- **本地构建失败**：运行 `bundle install` 以确保安装了所有 gem；检查 Ruby 版本是否兼容



