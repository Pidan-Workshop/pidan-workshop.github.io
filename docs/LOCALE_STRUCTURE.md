# _locale 目录结构指南

## 概述

`_locale/` 目录存储多语言翻译数据，采用**组件化设计**，每个组件或页面有对应的翻译文件，便于管理和维护。

**目录结构**：
- `_locale/common.yml` - 通用翻译（跨页面复用的文本）
- `_locale/includes/*.yml` - 组件翻译（header、footer 等）
- `_locale/*/index.yml` - 页面翻译（对应 `_templates/` 的页面）

**所有翻译在构建时会被合并注入到 `page.translations`，在模板中使用 `{{ page.translations.key }}` 访问。**

## 文件结构

```
_locale/
├── common.yml                # 🌐 通用翻译（按钮、消息、多页面标题等）
├── includes/                 # 📦 组件翻译目录
│   ├── header.yml            # 导航栏翻译
│   └── footer.yml            # 页脚翻译
├── index.yml                 # 主页翻译
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
**通用翻译**，用于跨多个页面复用的文本：
- 常用按钮（`play_now`, `learn_more`, `view_details`, `read_more`）
- 博客元素（`by`, `posted_on`）
- 导航控制（`back`, `next`, `previous`）
- 系统消息（`loading`, `error`）
- 多页面区段标题（`hero_title`, `games_title`, `blog_title`, `products_title`）

**访问方式**：`{{ page.common.key }}`

### _locale/includes/header.yml
**导航栏组件翻译**：
- `nav_home`, `nav_games`, `nav_products`, `nav_blog`, `nav_about`

**访问方式**：`{{ page.common.header.nav_home }}`

### _locale/includes/footer.yml
**页脚组件翻译**：
- `quick_links` - "快速链接"标题
- `follow_us` - "关注我们"标题
- `all_rights` - 版权声明

**访问方式**：`{{ page.common.footer.quick_links }}`

### _locale/index.yml
主页特定翻译内容（对应 `_templates/index.html`）。

### _locale/about/index.yml
关于页面翻译内容（对应 `_templates/about/index.html`）。

### _locale/games/index.yml
游戏列表页面翻译内容（对应 `_templates/games/index.html`）。

### _locale/blog/index.yml
博客索引页面翻译内容（对应 `_templates/blog/index.html`）。

### _locale/products/index.yml
产品页面翻译内容（对应 `_templates/products/index.html`）。

## 添加新翻译键

### 组件翻译（推荐用于 includes）

如果你正在为 `_includes/` 中的组件添加翻译：

1. 在 `_locale/includes/` 中创建对应的 `.yml` 文件（如 `_locale/includes/sidebar.yml`）
2. 添加翻译键：
```yaml
title:
  en: "Sidebar Title"
  zh: "侧边栏标题"
  
link_text:
  en: "View More"
  zh: "查看更多"
```

3. 在 include 文件中使用：
```liquid
<!-- _includes/sidebar.html -->
<h3>{{ page.translations.title }}</h3>
<a href="#">{{ page.translations.link_text }}</a>
```

**优点**：翻译和组件一对一对应，易于维护

### 通用翻译（用于跨页面复用）

如果某个翻译会在多个地方使用（如通用按钮）：

1. 编辑 `_locale/common.yml`
2. 添加新的键：
```yaml
submit:
  en: "Submit"
  zh: "提交"
```

3. 在任何模板中使用：
```liquid
{{ page.translations.submit }}
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
{{ page.translations.my_new_key }}
```

**注意**：所有翻译都会被合并到 `page.translations`，无论来自 common.yml、includes/*.yml 还是页面的 index.yml。

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

