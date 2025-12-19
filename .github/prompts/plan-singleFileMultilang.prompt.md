# Plan: 单文件多语言架构重构

将当前完全分离的双目录多语言架构（10个重复页面文件）重构为单文件模板方案。使用预构建脚本在 Jekyll 处理之前生成语言特定文件，实现内容集中管理同时保持 `/en/index` 等 URL 路由，无需任何 Jekyll 插件。

## Steps

1. **创建 `_templates/` 目录结构**：将 `en/index.html`、`en/about/index.html`、`en/games/index.html`、`en/blog/index.html`、`en/products/index.html` 作为模板基础移入，移除 `lang` 和 `title` front matter，仅保留 `ref` 和 `layout`。

2. **开发 Ruby 预构建脚本 `scripts/generate_pages.rb`**：读取 `_templates/` 中的每个模板，解析 front matter，为 `en` 和 `zh` 两种语言生成独立文件到原 `en/` 和 `zh/` 目录，根据 `_locale/` 中的翻译文件自动填充 `lang` 和 `title`。

3. **创建 `_locale/` 文件夹结构**：为不同功能创建模块化翻译文件，例如 `_locale/page_titles.yml` 包含所有页面的双语标题映射（如 `home: {en: "Pidan Workshop", zh: "皮蛋工作室"}`），供脚本查找标题。后续可扩展为 `_locale/nav.yml`、`_locale/common.yml` 等其他功能文件。

4. **配置 GitHub Actions 工作流 `.github/workflows/pages.yml`**：在 Jekyll 构建步骤前添加 `ruby scripts/generate_pages.rb`，确保每次推送时自动从模板生成语言文件；更新 `.gitignore` 排除 `en/` 和 `zh/` 目录（生成文件不入库）；将 `_locale/` 文件夹包含在版本控制中。

5. **博客文章不需要额外处理**：

6. **更新开发工作流文档**：在 `README.md` 中说明新架构下的修改流程（编辑 `_templates/` → 运行脚本 → 本地预览），移除旧的"需同步 en/zh 文件"指引。

## Further Considerations

### 1. 博客文章内容的多语言存储

**选项 B) 保持分离的博客文章**：
- 保持 `_posts/en/` 和 `_posts/zh/` 分离
- 仅页面模板使用 `_templates/` 方案
- 优点：博客内容通常较长，独立编辑更方便
- 缺点：博客文章仍需手动同步

**推荐：选项 B**，博客内容通常较长且独立编辑更方便。

### 2. 本地开发预览流程

**当前挑战**：
- 开发者修改模板后需手动运行 `ruby scripts/generate_pages.rb`
- 才能在 `bundle exec jekyll serve` 中看到更新
- 增加开发摩擦

**改进方案**：
- 使用 `guard` gem 监听 `_templates/` 目录变化
- 或使用 `nodemon` + npm scripts
- 自动触发脚本重新生成
- 配置 Jekyll 的 `--watch` 模式同时监听生成的文件

**示例 Guardfile**：
```ruby
guard :shell do
  watch(%r{^_templates/.+\.(html|md)$}) do |m|
    `ruby scripts/generate_pages.rb`
  end
end
```

### 3. 脚本错误处理与验证

**必需的验证**：
- 检查模板的 `ref` 在 `translations.yml` 的 `page_titles` 中存在
- 缺失时给出清晰的错误信息，指明缺失的 `ref`
- 验证生成的文件 front matter 格式正确

**可选功能**：
- `--dry-run` 选项：预览将生成的文件而不实际写入
- `--verbose` 选项：显示详细的处理日志
- `--validate` 选项：仅验证模板和翻译数据，不生成文件

**示例错误处理**：
```ruby
def validate_template(frontmatter)
  ref = frontmatter['ref']
  
  unless ref
    raise "Template missing 'ref' field in front matter"
  end
  
  unless TRANSLATIONS['page_titles'][ref]
    raise "No page_titles found for ref: #{ref}. Add it to _locale/page_titles.yml"
  end
end
```

### 4. 渐进式迁移策略

**阶段 1：基础设施**
- 创建脚本和 `_templates/` 目录
- 仅迁移首页 `index.html` 验证流程
- 测试 GitHub Actions 工作流

**阶段 2：静态页面**
- 迁移 about、games、products、blog 索引页
- 更新 `.gitignore`
- 验证所有链接正常工作

**阶段 3：博客文章（可选）**
- 根据需求决定是否重构博客文章
- 或保持现有 `_posts/en/` 和 `_posts/zh/` 结构

**阶段 4：文档和清理**
- 更新 README 和开发文档
- 移除旧的 `en/` 和 `zh/` 源文件
- 添加脚本使用说明

### 5. 替代技术方案

**方案对比**：

| 方案 | 优点 | 缺点 | GitHub Pages 兼容 |
|------|------|------|-------------------|
| **当前：双目录分离** | 简单直观，无构建步骤 | 高度重复，维护困难 | ✅ |
| **推荐：预构建脚本** | 单一模板源，易维护 | 需要构建步骤 | ✅ |
| **Jekyll Generator 插件** | 原生 Jekyll 集成 | 需要自定义插件 | ❌ |
| **JavaScript 客户端路由** | 真正单页面 | SEO 差，无直接访问 | ✅ |
| **查询参数 (?lang=zh)** | 最简单 | 破坏 SEO，不符合需求 | ✅ |

### 6. 性能和缓存考虑

**构建性能**：
- 脚本运行时间：通常 < 100ms（5个页面 × 2语言）
- GitHub Actions 增加构建时间约 1-2 秒
- 可接受的性能开销

**缓存策略**：
- 脚本可以检查模板文件修改时间
- 仅重新生成变更的页面
- 加速本地开发迭代

**示例缓存逻辑**：
```ruby
def needs_regeneration?(template_path, output_path)
  !File.exist?(output_path) || 
    File.mtime(template_path) > File.mtime(output_path)
end
```

### 7. 第三方工具集成

**推荐的开发工具**：
- **Guard**：自动监听文件变化并重新生成
- **foreman** / **overmind**：同时运行多个进程（脚本监听 + Jekyll serve）
- **make** / **npm scripts**：简化命令（如 `make dev` 启动完整开发环境）

**示例 Makefile**：
```makefile
.PHONY: generate dev build

generate:
	ruby scripts/generate_pages.rb

dev: generate
	bundle exec jekyll serve --watch

build: generate
	bundle exec jekyll build
```

### 8. 扩展到更多语言

**当前架构支持**：
- 在 `_data/languages.yml` 添加新语言
- 在 `_locale/` 的各翻译文件中添加翻译字符串
- 脚本自动支持任意数量语言（读取 `languages.yml` 和 `_locale/` 文件）

**示例添加日语**：
```yaml
# _data/languages.yml
ja:
  name: "日本語"
  flag: "🇯🇵"

# _locale/page_titles.yml
home:
  en: "Pidan Workshop"
  zh: "皮蛋工作室"
  ja: "ピダン工房"
```

脚本无需修改，自动生成 `ja/index.html` 等文件。

## 实现优先级

**必须实现（MVP）**：
1. ✅ 创建 `_templates/` 目录和脚本
2. ✅ 扩展 `translations.yml` 添加 `page_titles`
3. ✅ 生成静态页面（5个页面）
4. ✅ 配置 `.gitignore`
5. ✅ GitHub Actions 工作流

**应该实现**：
6. ✅ 脚本错误处理和验证
7. ✅ 本地开发工具（Guard 或 npm scripts）
8. ✅ 更新 README 文档

**可以实现（可选）**：
9. ⚪ 博客文章重构（可保持现有分离方案）
10. ⚪ 缓存优化
11. ⚪ --dry-run 和 --verbose 选项

## 风险评估

**技术风险**：
- **低风险**：预构建方案技术成熟，无复杂依赖
- **中风险**：开发者需要理解新工作流（修改模板 → 运行脚本）
- **缓解**：详细文档 + 简化命令（如 `make dev`）

**兼容性风险**：
- **零风险**：生成的文件与现有架构完全相同
- **回退策略**：保留旧文件，新旧方案可并存

**维护风险**：
- **低风险**：脚本逻辑简单（约 100 行 Ruby）
- **长期收益**：消除 10 个重复文件的维护负担

## 成功指标

1. ✅ 模板文件数量：从 10 个减少到 5 个
2. ✅ 生成文件正确性：所有 URL 路由保持不变
3. ✅ 构建时间增加 < 5 秒
4. ✅ 开发者反馈：工作流更简单（通过文档和实践验证）
5. ✅ 添加新语言时间：从 30 分钟减少到 5 分钟
