# Changelog

## [2.0.0] - 2025-12-19

### 🎉 Major Architecture Refactor: Single-File Multi-Language System

#### Added
- **Template System**: New `_templates/` directory for single-source page templates
- **Locale System**: New `_locale/` directory for modular translations
  - `_locale/page_titles.yml` for page title translations
- **Build Scripts**:
  - `scripts/generate_pages.rb` - Main page generation script with validation
  - `scripts/watch.rb` - Development watcher for auto-regeneration (optional)
- **Development Tools**:
  - `Makefile` with convenient commands (`make dev`, `make generate`, etc.)
- **Documentation**:
  - `docs/ARCHITECTURE.md` - Comprehensive architecture guide
  - Updated `README.md` with new workflow instructions
- **CI/CD**: GitHub Actions workflow (`.github/workflows/pages.yml`) for automated builds

#### Changed
- **Breaking**: Pages in `en/` and `zh/` are now auto-generated (not version controlled)
- **Workflow**: Developers now edit `_templates/` instead of language-specific directories
- `.gitignore` updated to exclude generated `en/` and `zh/` directories
- Build process now includes template generation step before Jekyll build

#### Benefits
- ✅ Reduced maintenance: 10 duplicate files → 5 template files
- ✅ Single source of truth for page content
- ✅ Automatic consistency across all languages
- ✅ Easy to add new languages (just update translation files)
- ✅ No Jekyll plugins needed (GitHub Pages compatible)
- ✅ Clear separation between content (templates) and translations (locale)

#### Migration Notes
- Existing `en/` and `zh/` files are preserved but should not be edited directly
- Run `ruby scripts/generate_pages.rb` to regenerate from templates
- Blog posts in `_posts/en/` and `_posts/zh/` remain unchanged

---

## [1.0.0] - 2025-12-18

### Initial Release
- Bilingual Jekyll site with English and Chinese support
- Dual-directory structure (`/en/` and `/zh/`)
- Game showcase system
- Blog with separate language directories
- Product display pages
- Responsive design
