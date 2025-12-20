# _locale 目录结构指南

## 概述

`_locale/` 目录存储多语言翻译数据，采用与 `_templates/` 目录相同的组织结构，便于管理和扩展。每个页面有一个对应的 `index.yml` 文件，包含该页面所有的翻译字符串。

**特殊文件**：
- `_locale/common.yml` - 存储全局通用翻译（导航、页脚、按钮等），会被插件自动注入到每个页面的 `page.common` 变量

## 文件结构

```
_locale/
├── common.yml                # 全局通用翻译（导航、页脚、按钮等）
├── index.yml                 # 主页（home）翻译
├── about/
│   └── index.yml             # 关于页面翻译
├── blog/
│   └── index.yml             # 博客页面翻译
├── games/
│   └── index.yml             # 游戏页面翻译
└── products/
    └── index.yml             # 产品页面翻译
```

**与 `_templates/` 结构对应关系**：

```
_templates/                    _locale/
├── index.html              ←→ ├── index.yml
├── about/                  ←→ ├── about/
│   └── index.html          ←→ │   └── index.yml
├── blog/                   ←→ ├── blog/
│   └── index.html          ←→ │   └── index.yml
├── games/                  ←→ ├── games/
│   └── index.html          ←→ │   └── index.yml
└── products/               ←→ └── products/
    └── index.html          ←→     └── index.yml
```

## 文件格式

每个 `index.yml` 文件包含多个翻译键，每个键支持多种语言：

```yaml
title:
  en: "English Title"
  zh: "中文标题"

description:
  en: "English description"
  zh: "中文描述"
```

## 页面文件说明

### _locale/common.yml
全局通用翻译，包含：
- 导航链接（`nav_home`, `nav_games`, `nav_products`, `nav_blog`, `nav_about`）
- 页脚文本（`footer_quick_links`, `footer_follow_us`, `footer_all_rights`）
- 常用按钮（`play_now`, `learn_more`, `view_details`, `read_more`）
- 博客元素（`by`, `posted_on`）
- 通用 UI（`loading`, `error`, `back`, `next`, `previous`）
- 主页区段标题（`hero_title`, `hero_subtitle`, `games_title`, `blog_title`, `products_title`）

这些翻译会被插件自动注入到每个页面的 `page.common` 变量。

### _locale/index.yml
主页特定翻译内容（对应 `_templates/index.html`），包括：
- `title`: 页面标题
- `hero_title`: 英雄区标题（如果需要覆盖 common.yml）
- `hero_subtitle`: 英雄区副标题
- `hero_cta`: 行动号召按钮文本

### _locale/about/index.yml
关于页面翻译内容（对应 `_templates/about/index.html`）。

### _locale/games/index.yml
游戏列表页面翻译内容（对应 `_templates/games/index.html`）。

### _locale/blog/index.yml
博客索引页面翻译内容（对应 `_templates/blog/index.html`）。

### _locale/products/index.yml
产品页面翻译内容（对应 `_templates/products/index.html`）。

## 添加新翻译键

### 全局通用翻译（导航、按钮等）

1. 编辑 `_locale/common.yml`
2. 添加新的键及其多语言翻译：
```yaml
my_new_button:
  en: "English text"
  zh: "中文文本"
```

3. 在模板中使用：
```liquid
{{ page.common.my_new_button }}
```

### 页面特定翻译

1. 编辑对应页面的 `index.yml` 文件（如 `_locale/about/index.yml`）
2. 添加新的键及其多语言翻译：
```yaml
my_new_key:
  en: "English text"
  zh: "中文文本"
```

3. 在 `_templates/` 中的对应 HTML/Markdown 模板里使用：
```liquid
{{ page.locale.my_new_key }}
```

## 添加新页面

1. 在 `_templates/` 中创建新的子目录和 `index.html` 文件（如 `_templates/news/index.html`）
2. 在模板的 front matter 中设置 `ref: news`
3. 在 `_locale/` 中创建对应的目录和 `index.yml` 文件
   ```
   _locale/news/index.yml
   ```
4. 在 `index.yml` 中定义 `title` 和其他翻译内容
5. 运行生成脚本

示例：添加"新闻"页面
```
_templates/news/index.html → ref: news
_locale/news/index.yml     → 包含所有翻译
↓ 生成脚本 ↓
en/news/index.html         → lang: en, title: "News"
zh/news/index.html         → lang: zh, title: "新闻"
```

## 扩展到新语言

1. 在 `_data/languages.yml` 中添加新语言
2. 在 `_locale/common.yml` 和所有 `_locale/**/*.yml` 文件的每个键中添加新语言的翻译
3. 运行构建：`.\build.ps1 dev` 或 `.\build.ps1 build`

示例：添加日语支持

```yaml
# _locale/common.yml
nav_home:
  en: "Home"
  zh: "首页"
  ja: "ホーム"

# _locale/index.yml
title:
  en: "Pidan Workshop"
  zh: "皮蛋工作室"
  ja: "ピダン工房"

hero_title:
  en: "Welcome to Pidan Workshop"
  zh: "欢迎来到皮蛋工作室"
  ja: "皮蛋工房へようこそ"
```

## 生成过程

运行脚本时，它会：
1. 读取 `_locale/` 及其子目录中的所有 `*.yml` 文件
2. 根据文件位置自动计算 `ref`：
   - `_locale/index.yml` → `ref: home`
   - `_locale/about/index.yml` → `ref: about`
   - `_locale/games/index.yml` → `ref: games`
3. 检查每个模板的 `ref` 值与 locale 文件是否匹配
4. 从对应的 `index.yml` 文件中提取 `title` 字段
5. 为每种语言生成 `en/` 和 `zh/` 目录下的页面
6. 自动添加 `lang` 和 `title` 到生成文件的 front matter

