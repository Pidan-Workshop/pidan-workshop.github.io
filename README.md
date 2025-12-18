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

## 🏗️ Project Structure

```
.
├── _config.yml          # Jekyll configuration
├── _data/               # Data files (translations, games metadata)
├── _includes/           # Reusable components (header, footer, etc.)
├── _layouts/            # Page layouts
├── _posts/              # Blog posts
│   ├── en/             # English posts
│   └── zh/             # Chinese posts
├── assets/              # Static assets (CSS, JS, images)
├── en/                  # English pages
│   ├── index.html
│   ├── games/
│   ├── products/
│   ├── blog/
│   └── about/
├── zh/                  # Chinese pages
│   └── [same structure as en/]
├── games/               # Individual game directories
│   └── sample-game/    # Each game has its own folder
└── index.html          # Language selection landing page
```

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

1. Install Ruby and Bundler
2. Clone this repository
3. Install dependencies:
   ```bash
   bundle install
   ```
4. Run Jekyll locally:
   ```bash
   bundle exec jekyll serve
   ```
5. Visit `http://localhost:4000`

## 🌍 Internationalization

This site uses a mature i18n system with the following features:

### Core Components

1. **Language Data Structure**
   - Separate directories for each language (`/en/`, `/zh/`)
   - Centralized translations in `_data/translations.yml`
   - Language metadata in `_data/languages.yml`

2. **Automatic Features**
   - Auto-detection of browser language on landing page
   - Language preference persistence via localStorage
   - SEO-friendly alternate language tags
   - Language switcher with page-specific linking

3. **Content Linking**
   - Use `ref` in page front matter to link translations
   - Example:
     ```yaml
     ---
     title: About
     lang: en
     ref: about
     ---
     ```

### Adding a New Language

1. Add language to `_data/languages.yml`:
   ```yaml
   fr:
     name: "Français"
     flag: "🇫🇷"
   ```

2. Add translations to `_data/translations.yml`:
   ```yaml
   fr:
     nav_home: "Accueil"
     # ... other translations
   ```

3. Create language-specific pages in `/fr/` directory

4. Update `_config.yml` defaults:
   ```yaml
   defaults:
     - scope:
         path: "fr"
       values:
         lang: "fr"
   ```

### Using Translations

In your layouts and pages:
```liquid
{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.nav_home }}</h1>
```

Or use the i18n helper:
```liquid
{% include i18n-helper.html key="nav_home" %}
```

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
