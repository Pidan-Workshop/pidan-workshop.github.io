# CSS 模块化结构

## 概述
CSS 已从单一的 `main.css` 重构为多个模块化文件，便于维护、扩展和性能优化。

## 文件结构

```
assets/css/
├── variables.css      - 全局变量、reset 和基础样式
├── header.css         - 导航栏、header 样式
├── footer.css         - 页脚样式
├── buttons.css        - 按钮和交互元素样式
├── hero.css           - 首页 Hero 段落
├── cards.css          - 卡片组件（游戏卡、产品卡、博客卡）
├── layouts.css        - 网格布局、页面结构
├── blog.css           - 博客页面、文章内容
├── about.css          - 关于页面
├── game-detail.css    - 游戏详情页专用样式
└── utilities.css      - 工具类
```

## 各文件职责

| 文件 | 职责 |
|------|------|
| **variables.css** | CSS 自定义属性（color、shadow 等）、通用 reset、body 和 .container 基础样式 |
| **header.css** | `.site-header`、`.main-nav`、`.language-switcher`、响应式断点 |
| **footer.css** | `.site-footer`、`.footer-content`、`.footer-section` 等页脚组件 |
| **buttons.css** | `.btn-primary`、`.btn-secondary`、`.fullscreen-btn` 等所有按钮样式 |
| **hero.css** | `.hero`、`.hero-title`、`.hero-subtitle` 及响应式 |
| **cards.css** | `.game-card`、`.product-card`、`.post-preview`、`.tag` 等卡片组件 |
| **layouts.css** | `.games-grid`、`.page-header`、`.content`、`.featured-games` 等版面布局 |
| **blog.css** | `.post`、`.post-content`、`.post-meta`、`.post-navigation` 等博客内容样式 |
| **about.css** | `.about-content` 和关于页面专用样式 |
| **game-detail.css** | **游戏详情页专用** - `.game-detail-*` 开头的所有类以及游戏展示样式 |
| **utilities.css** | `.text-center` 等工具类 |

## 模板引入方式

### default.html（大多数页面）
```html
<link rel="stylesheet" href="{{ '/assets/css/variables.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/header.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/footer.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/buttons.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/hero.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/cards.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/layouts.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/blog.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/about.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/utilities.css' | relative_url }}">
```

### game-wrapper.html（游戏详情页）
```html
<link rel="stylesheet" href="{{ '/assets/css/variables.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/header.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/footer.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/buttons.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/cards.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/layouts.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/game-detail.css' | relative_url }}">
<link rel="stylesheet" href="{{ '/assets/css/utilities.css' | relative_url }}">
```

## 添加新页面的 CSS

如果需要为新页面添加特定样式：

1. **创建新文件**：`assets/css/page-name.css`
2. **在模板中引入**：在对应的 `_layouts/*.html` 中添加 `<link>` 标签
3. **保持命名一致**：使用 `.page-name-*` 前缀的类选择器

示例：添加 "产品详情页" 样式
```css
/* assets/css/product-detail.css */
.product-detail-header { ... }
.product-detail-grid { ... }
```

## 优化建议

### 现在可做的优化：
1. ✅ 按需加载 CSS（不同页面加载不同的 CSS）
2. ✅ 压缩和合并（生产环境可用构建工具）
3. ✅ 更好的代码组织和维护性

### 未来可考虑：
- SCSS/SASS 预处理器
- CSS Modules 或 BEM 命名约定
- 自动化 CSS 打包和最小化

## 注意事项

- ⚠️ **不要混淆样式**：game-detail.css 的样式只用于游戏详情页
- ⚠️ **响应式断点**：保持在各自的 CSS 文件中（用 `@media` 查询）
- ✅ **变量优先**：使用 `variables.css` 中的 CSS 自定义属性保持颜色和尺寸一致
- ✅ **保持简洁**：每个文件专注于一个功能区域

## 迁移日志

**日期**：2025-12-20  
**变更**：从单一 `main.css` 拆分为 11 个模块化 CSS 文件  
**备份**：原始文件保存为 `main.css.bak`  
**模板更新**：`_layouts/default.html` 和 `_layouts/game-wrapper.html` 已更新以引入新的 CSS 文件
