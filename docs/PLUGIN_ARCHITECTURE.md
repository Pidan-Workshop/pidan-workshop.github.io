# Jekyll 插件多语言架构指南

## 概述

本项目使用 **Jekyll 插件** 方案实现多语言支持，在构建时自动生成多语言页面，无需维护临时的 `/en` 和 `/zh` 目录。

### 核心优势
- ✅ **自动生成**：Jekyll 构建时自动生成多语言页面到 `_site`
- ✅ **无临时文件**：不需要创建和维护 `/en` 和 `/zh` 目录
- ✅ **开发简单**：只需运行 `.\build.ps1 dev`，无需手动执行生成脚本
- ✅ **GitHub Pages 兼容**：完全兼容 GitHub Pages 构建流程

## 架构说明

### 工作流程

```
Jekyll 构建开始
  ↓
_plugins/locale_generator.rb 运行
  ↓
读取 _templates/ 和 _locale/
  ↓
为每种语言生成 LocalePage 对象
  ↓
Jekyll 渲染页面到 _site/en/ 和 _site/zh/
  ↓
构建完成
```

### 目录结构

```
_templates/          # 📝 页面模板（编辑这里）
├── index.html
├── about/
├── games/
└── products/

_locale/             # 🌍 翻译数据
├── index.yml
├── about/
├── games/
└── products/

_plugins/            # 🔧 Jekyll 插件
└── locale_generator.rb  # 多语言生成器

_site/               # 🏗️ 构建输出（自动生成）
├── en/
│   ├── index.html
│   ├── about/
│   └── games/
└── zh/
    ├── index.html
    ├── about/
    └── games/
```

**关键点**：
- ❌ **不再需要** `/en` 和 `/zh` 目录在项目根目录
- ✅ 页面直接生成到 `_site/en/` 和 `_site/zh/`
- ✅ 模板和 locale 数据保持不变

## 插件工作原理

### locale_generator.rb

插件在 Jekyll 构建的 `generate` 阶段运行：

1. **加载配置**：读取 `_data/languages.yml` 获取支持的语言列表
2. **加载翻译**：读取 `_locale/` 目录中的所有 `.yml` 文件
3. **处理模板**：遍历 `_templates/` 中的所有模板文件
4. **生成页面**：为每种语言创建 `LocalePage` 对象并添加到 Jekyll 的页面集合
5. **自动渲染**：Jekyll 自动将页面渲染到 `_site`

### LocalePage 类

自定义页面类，继承自 `Jekyll::Page`：

```ruby
class LocalePage < Page
  def initialize(site, base, lang, relative_path, front_matter, body)
    # 设置语言、标题、permalink 等
    # 将 locale 数据注入到页面
  end
end
```

**关键特性**：
- 自动设置 `lang`、`title`、`permalink`
- 将整个 `locale` 数据注入到 `page.locale`
- 模板中可通过 `{{ page.locale.key }}` 访问翻译

## 使用指南

### 开发工作流

```bash
# 启动开发服务器
.\build.ps1 dev

# 访问 http://localhost:4000
# 插件会自动生成多语言页面
```

### 创建新页面

1. **创建模板**：`_templates/contact/index.html`
```html
---
layout: default
ref: contact
---

<h1>{{ page.locale.title }}</h1>
<p>{{ page.locale.description }}</p>
```

2. **添加翻译**：`_locale/contact/index.yml`
```yaml
title:
  en: "Contact Us"
  zh: "联系我们"
  
description:
  en: "Get in touch"
  zh: "联系我们"
```

3. **构建测试**：
```bash
.\build.ps1 dev
```

### 访问翻译数据

所有翻译统一通过 `page.translations` 访问，无论来源：

```liquid
<!-- 页面特定翻译 -->
{{ page.translations.hero_title }}

<!-- 组件翻译（来自 _locale/includes/） -->
{{ page.translations.nav_home }}
{{ page.translations.quick_links }}

<!-- 通用翻译（来自 _locale/common.yml） -->
{{ page.translations.play_now }}
{{ page.translations.by }}
```

**插件工作流程**：
1. 加载页面特定翻译（`_locale/*/index.yml`）
2. 加载通用翻译（`_locale/common.yml`）
3. 加载组件翻译（`_locale/includes/*.yml`）
4. 将所有翻译合并到 `page.translations`
5. 自动注入到每个生成的页面

## 配置说明

### _config.yml

```yaml
# Exclude from processing
exclude:
  - _templates/  # 模板不直接输出
  - _locale/     # locale 数据不直接输出
  - scripts/     # 构建脚本不输出
```

### .gitignore

```gitignore
_site/
.jekyll-cache/
# 注意：不再排除 /en 和 /zh 目录
```

## 添加新语言

1. 在 `_data/languages.yml` 添加新语言：
```yaml
ja:
  name: "日本語"
  flag: "🇯🇵"
```

2. 在所有 `_locale/**/*.yml` 文件中添加日语翻译：
```yaml
title:
  en: "Home"
  zh: "首页"
  ja: "ホーム"
```

3. 重新构建：
```bash
.\build.ps1 build
```

插件会自动生成 `_site/ja/` 目录。

## 故障排除

### 问题：页面未生成

**检查**：
1. 模板是否有 `ref` 字段
2. `_locale/` 中是否有对应的翻译文件
3. 翻译文件中是否有 `title` 字段

**调试**：
```bash
.\build.ps1 build
# 查看 Jekyll 构建日志
```

### 问题：翻译未显示

**原因**：可能使用了错误的访问方式

**解决**：
- 页面特定翻译：`{{ page.locale.key }}`
- 全局翻译：`{{ site.data.translations[page.lang].key }}`

### 问题：GitHub Pages 构建失败

**原因**：GitHub Pages 有插件限制

**解决**：使用 GitHub Actions 自定义构建流程

## 与旧方案的对比

| 特性 | 旧方案 (scripts) | 新方案 (_plugins) |
|------|-----------------|-------------------|
| 临时目录 | 需要 `/en` `/zh` | ❌ 不需要 |
| 手动生成 | ✅ 需要运行脚本 | ❌ 自动生成 |
| 开发体验 | 需要额外步骤 | 🎯 无缝集成 |
| Git 管理 | 需要 .gitignore | 更简洁 |
| 构建速度 | 两次处理 | 一次完成 |
| 代码维护 | 外部脚本 | Jekyll 原生 |

## 迁移指南

### 从旧方案迁移

1. ✅ 复制 `_plugins/locale_generator.rb`
2. ✅ 更新 `_config.yml` 排除列表
3. ✅ 更新 `.gitignore` 移除 `/en` `/zh` 排除
4. ✅ 更新 `build.ps1` 移除 generate 命令
5. ✅ 删除 `/en` 和 `/zh` 目录（如果存在）
6. ✅ 测试构建：`.\build.ps1 dev`

### 模板兼容性

**无需修改**：
- `_templates/` 中的模板文件
- `_locale/` 中的翻译文件
- `_posts/` 中的博客文章

插件完全兼容旧的模板结构。

## 性能说明

- **构建时间**：与旧方案相当，约 2-3 秒
- **内存占用**：轻微增加（页面对象保留在内存）
- **开发体验**：✅ 显著改善（无需手动运行脚本）

## GitHub Actions 配置

`.github/workflows/pages.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.1'
          bundler-cache: true
      
      - name: Build with Jekyll
        run: bundle exec jekyll build
        # 插件会自动运行，无需额外步骤
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: _site
```

## 相关文件

- 主文档：[README.md](../README.md)
- Locale 结构：[LOCALE_STRUCTURE.md](./LOCALE_STRUCTURE.md)
- 游戏集成：[GAME_INTEGRATION.md](./GAME_INTEGRATION.md)
- 插件源码：[_plugins/locale_generator.rb](../_plugins/locale_generator.rb)
