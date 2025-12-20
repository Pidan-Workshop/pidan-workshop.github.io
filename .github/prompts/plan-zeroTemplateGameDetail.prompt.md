# Plan: 重新设计游戏详情页面 —— 零模板方案

**核心思路**：利用 Jekyll 的数据驱动能力，只需在 `_data/games.yml` 中添加游戏元数据，通过自定义 Defold 导出页面为"外壳页面"来集成多语言导航和信息展示。无需创建新模板文件，仅需修改游戏部署流程。

## Steps

### 1. 扩展 `_data/games.yml` 元数据

为每个游戏添加可选的 `embed_width`、`embed_height` 字段，同时保留现有的多语言 `title` 和 `description`。

**示例**：
```yaml
- id: bomb-frog
  title:
    en: "Bomb Frog"
    zh: "炸弹青蛙"
  description:
    en: |
      Collect bombs and use them to uncover hidden treasure...
    zh: |
      收集炸弹，用它们来发现隐藏的宝藏并消灭幽灵...
  thumbnail: "/assets/images/games/bomb-frog.png"
  path: "/games/bomb-frog/"
  release_date: 2025-12-18
  tags: ["pixel-art", "2d"]
  featured: true
  embed_width: 1280        # 新增（可选）
  embed_height: 720        # 新增（可选）
```

### 2. 创建 `game-wrapper.html` 包装层

在 `_layouts/` 创建新布局，作为所有游戏的通用外壳——包含：
- Jekyll 导航头尾（从 `_includes/header.html` 和 `_includes/footer.html`）
- 从 `site.data.games` 动态查询游戏元数据
- 通过 URL 路径或前端逻辑提取游戏 ID
- 集成 iframe 或嵌入原游戏 HTML

**核心逻辑**：
```liquid
{% assign game = site.data.games | where: "id", page.game_id | first %}

<div class="game-container">
  <h1>{{ game.title[page.lang] }}</h1>
  <div class="game-embed">
    <iframe src="/games/{{ page.game_id }}/native.html" 
            width="{{ game.embed_width | default: 1280 }}" 
            height="{{ game.embed_height | default: 720 }}"></iframe>
  </div>
  <div class="game-info">
    <p>{{ game.description[page.lang] }}</p>
    <div class="game-tags">
      {% for tag in game.tags %}
      <span class="tag">{{ tag }}</span>
      {% endfor %}
    </div>
  </div>
</div>
```

### 3. 修改游戏部署策略

**新游戏部署流程**：
- 上传 Defold 导出文件到 `/games/game-id/` 目录
- **重命名** Defold 导出的 `index.html` 为 `native.html`（游戏本体）
- 在 `/games/game-id/` 中放置一个新的 `index.html`，使用 `game-wrapper` 布局并声明 `game_id` front matter
- 在 `_data/games.yml` 中添加游戏元数据

**新 `/games/bomb-frog/index.html` 示例**：
```yaml
---
layout: game-wrapper
ref: game-bomb-frog
game_id: bomb-frog
lang: en
permalink: /games/bomb-frog/
---
```

**关键点**：
- `native.html` 是原始的 Defold 导出文件（被 iframe 加载）
- `index.html` 是 Jekyll 处理的外壳页面
- 无需修改 `_templates/` 或 `_locale/`
- 无需修改生成脚本

### 4. 在 `_locale/` 中添加游戏通用翻译

创建 `_locale/games/game-detail.yml`，包含游戏详情页的通用文本，具体游戏标题/描述仍从 `games.yml` 读取。

**示例 `_locale/games/game-detail.yml`**：
```yaml
back_to_games:
  en: "Back to Games"
  zh: "返回游戏列表"

share_game:
  en: "Share"
  zh: "分享"

released:
  en: "Released"
  zh: "发布日期"

tags:
  en: "Tags"
  zh: "标签"

fullscreen:
  en: "Fullscreen"
  zh: "全屏"
```

### 5. 扩展 CSS 和前端逻辑

添加游戏容器样式，支持：
- 响应式 iframe 布局
- 全屏功能
- 加载状态
- 移动端适配

**关键 CSS 类**：
```css
.game-container { }
.game-embed { }
.game-info { }
.game-tags { }
.fullscreen-btn { }
```

### 6. 多语言页面生成

**两种方案选择**：

#### 方案 A：自动为每种语言生成页面
- 在生成脚本中添加逻辑，为 `_data/games.yml` 中的每个游戏自动生成 `/en/games/game-id/index.html` 和 `/zh/games/game-id/index.html`
- 优点：URL 结构统一 `/en/games/bomb-frog/` 和 `/zh/games/bomb-frog/`
- 缺点：需要修改生成脚本

#### 方案 B：前端语言切换
- `/games/game-id/index.html` 保留单一版本
- 通过前端 JavaScript 根据 `page.lang` 或 localStorage 切换语言
- 优点：无需修改生成脚本，部署最简单
- 缺点：URL 不包含语言段，SEO 可能受影响

---

## 核心优势

✅ **零模板方案**：无需为每个游戏创建模板文件  
✅ **最小改动**：只需扩展 `games.yml` 和添加一个 `game-wrapper.html` 布局  
✅ **自动扩展**：新游戏部署时仅需上传文件和更新元数据  
✅ **一致体验**：所有游戏共享统一的多语言导航和信息展示  
✅ **易于维护**：生成脚本无需改动（如果选择方案 B）

---

## 进一步需要确认

1. **多语言页面生成**：选择方案 A（自动生成多语言版本 + 修改脚本）还是方案 B（前端语言切换 + 无脚本修改）？

2. **iframe vs. 混合嵌入**：
   - 使用 iframe 加载 `native.html`：隔离性好，但跨域风险
   - 使用 fetch 注入游戏 HTML：需要修改 Defold 导出文件结构

3. **向后兼容性**：现有游戏的 `games/bomb-frog/index.html` 如何处理？
   - 直接替换为外壳页面（新部署模式）
   - 保留原文件，新增 wrapper 版本
   - 通过 `.htaccess` 或 URL 重写来管理

4. **Defold 文件命名约定**：
   - 将所有 Defold 导出的 `index.html` 改名为 `native.html`？
   - 还是使用其他命名约定（如 `game.html`、`defold-index.html`）？

