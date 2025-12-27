# Pidan Workshop

Welcome to the official GitHub repository for Pidan Workshop's website! This is a multi-functional GitHub Pages site featuring product showcases, HTML5 games, and a bilingual blog.

## 🌐 Live Site

Visit us at: [https://pidanworshop.github.io](https://pidanworshop.github.io)

## ✨ Features

- **Bilingual Support**: Full Chinese (简体中文) and English support
- **Game Showcase**: Display and play HTML5 games built with Defold
- **Product Display**: Showcase creative products and tools
- **Blog System**: Share updates, tutorials, and insights
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Jekyll-Powered**: Static site generation with Jekyll for GitHub Pages
- **Plugin-Based i18n**: Automatic multi-language page generation via Jekyll plugin

## 🏗️ Project Structure

```
.
├── _config.yml          # Jekyll configuration
├── _data/               # Data files (games metadata, languages)
├── _includes/           # Reusable components (header, footer, etc.)
├── _layouts/            # Page layouts
├── _locale/             # Multi-language translation data (YAML)
│   ├── common.yml       # 🌍 Common translations (buttons, messages, multi-page titles)
│   ├── includes/        # 📦 Component translations (header, footer, etc.)
│   │   ├── header.yml   # Navigation translations
│   │   └── footer.yml   # Footer translations
│   ├── index.yml
│   ├── about/
│   ├── games/
│   └── products/
├── _templates/          # Multi-language page templates (source)
│   ├── index.html
│   ├── about/
│   ├── games/
│   ├── blog/
│   └── products/
├── _plugins/            # Jekyll plugins
│   └── locale_generator.rb  # 🔧 Auto-generates multi-language pages during build
├── _posts/              # Blog posts
│   ├── en/             # English posts
│   └── zh/             # Chinese posts
├── assets/              # Static assets (CSS, JS, images)
├── games/               # Individual game directories
│   └── sample-game/    # Each game has its own folder
├── _site/               # Built site (auto-generated)
│   ├── en/             # English pages
│   └── zh/             # Chinese pages
└── index.html          # Language selection landing page
```

**Note**: The `_site/en/` and `_site/zh/` directories are **automatically generated** by the Jekyll plugin during build - they are not committed to version control.

## 🎮 Adding a New Game

1. Create a new directory under `games/`:
   ```
   games/your-game-name/
   ```

2. Add your Defold HTML5 export files to this directory

3. Update `_data/games.yml` with your game metadata:
   ```yaml
   - id: your-game-name
     title:
       en: "Your Game Title"
       zh: "游戏标题"
     description:
       en: "Game description"
       zh: "游戏描述"
     thumbnail: "/assets/images/games/your-game-thumb.jpg"
     path: "/games/your-game-name/"
     release_date: 2025-12-18
     tags: ["platformer", "2d"]
     featured: true
   ```

## 📝 Adding Blog Posts

Create a new Markdown file in `_posts/en/` or `_posts/zh/`:

```markdown
---
layout: post
title: "Your Post Title"
date: 2025-12-18
author: Your Name
tags: [tag1, tag2]
lang: en
---

Your content here...
```

## 🛠️ Local Development

### Prerequisites
- Ruby 3.1+ with Bundler installed (Ruby 3.4+ requires additional standard library gems)
- Git

### Setup and Run

1. Clone this repository
   ```bash
   git clone https://github.com/Pidan-Workshop/pidan-workshop.github.io.git
   cd pidan-workshop.github.io
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. **Start the development server**:
   
   **On Windows (PowerShell):**
   ```powershell
   .\build.ps1 dev
   ```
   
   **On macOS/Linux:**
   ```bash
   make dev
   ```
   
   The Jekyll plugin automatically generates multi-language pages during the build process.

4. Visit `http://localhost:4000`

### Build Commands Reference

#### For Windows (PowerShell):
```powershell
# Development server (auto-generates pages)
.\build.ps1 dev

# Build for production
.\build.ps1 build

# Clean generated files
.\build.ps1 clean

# Show help
.\build.ps1 help
```

#### For macOS/Linux:
```bash
# Development server (auto-generates pages)
make dev

# Build for production
make build

# Clean generated files
make clean

# Show help
make help
```

### Important: Plugin-Based Multi-Language Architecture

This site uses a **Jekyll plugin-based system** for automatic multi-language page generation:

- **Source templates** in `_templates/` directory (one per page)
- **Translation data** in `_locale/` directory (organized by page)  
- **Automatic generation** during Jekyll build to `_site/en/` and `_site/zh/`
- **No temporary files** - pages generated directly to `_site`
- **No manual scripts** - just run Jekyll, plugin does the rest

📖 For complete architecture details, see [docs/PLUGIN_ARCHITECTURE.md](docs/PLUGIN_ARCHITECTURE.md)

### Editing Existing Pages

1. **Edit the template** in `_templates/`:
   ```html
   _templates/about/index.html
   ```

2. **Update translations** in `_locale/`:
   ```yaml
   _locale/about/index.yml
   ```

3. **Save and refresh** - Jekyll automatically rebuilds with LiveReload

4. **View changes** at:
   - English: `http://localhost:4000/en/about/`
   - Chinese: `http://localhost:4000/zh/about/`

### Creating New Pages

1. **Create a template** in `_templates/contact/index.html`:
   ```html
   ---
   layout: default
   ref: contact
   ---
   
   <h1>{{ site.data.translations[page.lang].contact_title }}</h1>
   <!-- Template HTML here -->
   ```

2. **Add translations** in `_locale/contact/index.yml`:
   ```yaml
   title:
     en: "Contact Us"
     zh: "联系我们"
   ```

3. **Save file** - plugin automatically generates pages

4. **Access at**:
   - English: `http://localhost:4000/en/contact/`
   - Chinese: `http://localhost:4000/zh/contact/`

## 🌍 Internationalization

This site uses a **Jekyll plugin-based multi-language system**:

### Architecture Overview
- **Single source templates** in `_templates/` directory
- **Translation data** in `_locale/` directory (organized by page)
- **Component translations** in `_locale/includes/` (header, footer, etc.)
- **Common translations** in `_locale/common.yml` (buttons, messages, multi-page titles)
- **Plugin auto-generation** during Jekyll build to `_site/en/` and `_site/zh/`

For detailed information, see [docs/PLUGIN_ARCHITECTURE.md](docs/PLUGIN_ARCHITECTURE.md)

### Automated Deployment

The GitHub Actions workflow (`.github/workflows/pages.yml`) automatically:
1. Installs Ruby and dependencies
2. Runs Jekyll build (plugin generates pages automatically)
3. Deploys to GitHub Pages

**No manual generation needed** - just commit and push your changes to the `main` branch

### Architecture Overview
1. **Source files** in `_templates/` and `_locale/`
2. **Plugin activation** - `_plugins/locale_generator.rb` runs at build time
3. **Page generation** - creates `LocalePage` objects for each language
4. **Rendering** - Jekyll renders directly to `_site/en/` and `_site/zh/`
5. **Language linking** - `ref` field connects translations automatically

### Benefits
- ✅ Single source of truth for page content
- ✅ No temporary files or directories
- ✅ Automatic page generation during build
- ✅ Easy to add new languages
- ✅ Seamless development experience
- ✅ Works with GitHub Pages custom workflows

## 🚀 Deployment

This site is automatically deployed via GitHub Pages when you push to the `main` branch. No additional configuration needed!

## 📄 License

All rights reserved © 2025 Pidan Workshop

## 🤝 Contributing

We welcome contributions! Feel free to open issues or submit pull requests.

## 📧 Contact

- GitHub: [@Pidan-Workshop](https://github.com/Pidan-Workshop)
- Website: [pidanworshop.github.io](https://pidanworshop.github.io)

---

Made with ❤️ by Pidan Workshop
