# Changelog

## [Unreleased]

### Changed
- **Locale Structure**: Migrated `_data/translations.yml` to `_locale/common.yml` for consistent data structure
  - All global translations (nav, footer, buttons) now in `_locale/common.yml`
  - Unified access pattern: `{{ page.common.key }}` instead of `{{ site.data.translations[page.lang].key }}`
  - Plugin automatically loads common translations and injects into each page
- **Template Simplification**: Removed `{% assign t = site.data.translations[page.lang] %}` from all templates
- **Documentation**: Updated all docs to reflect new translation access patterns

### Removed
- `_data/translations.yml` - replaced by `_locale/common.yml`

## [2.0.0] - 2025-12-19

### 🎉 Major Architecture Refactor: Template + Locale Multi-Language System

#### Added
- **Template System**: New `_templates/` directory for single-source page templates
- **Locale System**: New `_locale/` directory for modular, language-specific content
  - YAML-based multi-language content organization
  - Hierarchical structure matching page categories
- **Build Automation**:
  - `scripts/generate_pages.rb` - Page generation script with validation
  - `build.ps1` - Windows PowerShell build script with commands: `dev`, `generate`, `serve`, `build`, `clean`
  - `Makefile` - Cross-platform build commands for macOS/Linux
- **Development Tools**:
  - Automated page generation from templates + locale files
  - Live reload with `--livereload` flag
- **Documentation**:
  - `docs/ARCHITECTURE.md` - Comprehensive architecture guide
  - `docs/LOCALE_STRUCTURE.md` - Locale file structure documentation
  - `docs/IMPLEMENTATION_SUMMARY.md` - Implementation details
  - Updated `README.md` with new workflow and build commands
- **CI/CD**: GitHub Actions workflow for automated builds and deployment

#### Changed
- **Breaking**: Pages in `en/` and `zh/` are now auto-generated (not version controlled)
- **Workflow**: Developers edit `_templates/` and `_locale/` instead of language-specific directories
- **Build Process**: Introduction of `build.ps1` (Windows) and `Makefile` (Unix-like systems)
- `.gitignore` updated to exclude generated `en/` and `zh/` directories
- Content is now split between templates (structure) and locale files (translations)

#### Build Commands
**Windows (PowerShell):**
- `.\build.ps1 dev` - Development with auto-regeneration
- `.\build.ps1 generate` - Generate pages from templates
- `.\build.ps1 serve` - Jekyll server only
- `.\build.ps1 build` - Production build
- `.\build.ps1 clean` - Clean generated files

**macOS/Linux (Makefile):**
- `make dev` - Development with auto-regeneration
- `make generate` - Generate pages from templates
- `make serve` - Jekyll server only
- `make build` - Production build
- `make clean` - Clean generated files

#### Benefits
- ✅ Reduced maintenance: 10 duplicate files → 5 template files + 5 locale files
- ✅ Single source of truth for page content
- ✅ Automatic consistency across all languages
- ✅ Easy to add new languages (just update locale files)
- ✅ No Jekyll plugins needed (GitHub Pages compatible)
- ✅ Clear separation between structure (templates) and content (locale)
- ✅ Cross-platform build support (Windows, macOS, Linux)

#### Migration Notes
- Existing `en/` and `zh/` files are preserved but should not be edited directly
- Run `.\build.ps1 generate` (Windows) or `make generate` (Unix-like) to regenerate
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
