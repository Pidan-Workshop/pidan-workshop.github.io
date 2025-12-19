# Pidan Workshop

Welcome to the official GitHub repository for Pidan Workshop's webse! This is a multi-functional GitHub Pages site featuring product showcases, HTML5 games, and a bilingual blog.

## 🌐 Live Site

Visit us at: [https://pidanworshop.github.io](https://pidanworshop.github.io)

## ✨ Features

- **Bilingual Support**: Full Chinese (简体中文) and English support
- **Game Showcase**: Display and play HTML5 games built with Defold
- **Product Display**: Showcase creative products and tools
- **Blog System**: Share updates, tutorials, and insights
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Jekyll-Powered**: Static site generation with Jekyll for GitHub Pages

## 🏗️ Project Structure

```
.
├── _config.yml          # Jekyll configuration
├── _data/               # Data files (translations, games metadata)
├── _includes/           # Reusable components (header, footer, etc.)
├── _layouts/            # Page layouts
├── _locale/             # Page title translations
│   └── page_titles.yml
├── _templates/          # Multi-language page templates (source)
│   ├── index.html
│   ├── about/
│   ├── games/
│   ├── blog/
│   └── products/
├── _posts/              # Blog posts
│   ├── en/             # English posts
│   └── zh/             # Chinese posts
├── scripts/             # Build scripts
│   └── generate_pages.rb  # Generate language pages from templates
├── assets/              # Static assets (CSS, JS, images)
├── en/                  # English pages (auto-generated)
│   ├── index.html
│   ├── games/
│   ├── products/
│   ├── blog/
│   └── about/
├── zh/                  # Chinese pages (auto-generated)
│   └── [same structure as en/]
├── games/               # Individual game directories
│   └── sample-game/    # Each game has its own folder
└── index.html          # Language selection landing page
```

**Note**: Files in `en/` and `zh/` are auto-generated from `_templates/` and excluded from version control.

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
ref: unique-post-id
lang: en
---

Your content here...
```

## 🛠️ Local Development

### Prerequisites
- Ruby 3.1+ and Bundler installed
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

3. **Generate multi-language pages from templates**:
   ```bash
   ruby scripts/generate_pages.rb
   ```

4. Run Jekyll locally:
   ```bash
   bundle exec jekyll serve
   ```

5. Visit `http://localhost:4000`

### Important: Template-Based Architecture

This site uses a **single-file multi-language architecture**:

- **Edit templates** in `_templates/` directory (NOT `en/` or `zh/` directly)
- **Run generation script** to create language-specific files:
  ```bash
  ruby scripts/generate_pages.rb
  ```
- **Files in `en/` and `zh/`** are auto-generated and git-ignored

### Making Changes to Pages

1. Edit the template file in `_templates/`:
   ```bash
   # Example: edit homepage
   _templates/index.html
   ```

2. Run the generation script:
   ```bash
   ruby scripts/generate_pages.rb
   ```

3. Preview changes:
   ```bash
   bundle exec jekyll serve
   ```

### Adding New Page Titles

When creating a new page template with a new `ref` value:

1. Add the page title to `_locale/page_titles.yml`:
   ```yaml
   new-page:
     en: "New Page Title"
     zh: "新页面标题"
   ```

2. Create the template in `_templates/` with the matching `ref`:
   ```yaml
   ---
   layout: default
   ref: new-page
   ---
   ```

## 🌍 Internationalization

This site uses a **template-based multi-language system**:

### Architecture Overview
- **Single source templates** in `_templates/` directory
- **Language-specific files** auto-generated to `en/` and `zh/`
- **Translation data** in `_data/translations.yml` for UI strings
- **Page titles** in `_locale/page_titles.yml`
- **Build script** (`scripts/generate_pages.rb`) generates all language versions


### Automated Build Process

The GitHub Actions workflow (`.github/workflows/pages.yml`) automatically:
1. Runs `ruby scripts/generate_pages.rb` to generate language-specific pages
2. Builds the Jekyll site
3. Deploys to GitHub Pages

**No manual generation needed** - just push your template changes to `main` branch
### How It Works
1. Templates in `_templates/` contain only `layout` and `ref` in front matter (no `lang` or `title`)
2. Generation script reads templates and creates language-specific files
3. Each generated file gets appropriate `lang` and `title` from `_locale/page_titles.yml`
4. Language switcher component links translations using `ref` values

### Benefits
- ✅ Single source of truth for page content
- ✅ No duplicate HTML files to maintain
- ✅ Easy to add new languages
- ✅ Automatic consistency across translations
- ✅ Works with GitHub Pages (no custom plugins needed)

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
