# Internationalization (I18n) Guide

This document explains the comprehensive internationalization system implemented for Pidan Workshop.

## 🌍 Overview

The website supports multiple languages with a mature, production-ready i18n solution that includes:

- ✅ **Language Detection**: Automatic browser language detection
- ✅ **Language Persistence**: Saves user preference via cookies and localStorage
- ✅ **SEO Optimization**: Proper hreflang tags and Open Graph locale support
- ✅ **Fallback System**: Graceful handling of missing translations
- ✅ **Accessible**: ARIA labels and semantic HTML
- ✅ **Performance**: Minimal JavaScript, static site generation

## 📁 File Structure

```
├── _data/
│   ├── languages.yml          # Language metadata (name, flag)
│   └── translations.yml        # All UI translations
├── _includes/
│   ├── language-switcher.html  # Language switcher component
│   ├── i18n-seo.html          # SEO tags (hreflang, canonical)
│   ├── i18n-helpers.html      # Translation helper functions
│   └── i18n-sitemap.xml       # Language-aware sitemap template
├── assets/js/
│   └── i18n.js                # Client-side i18n utilities
├── en/                        # English pages
├── zh/                        # Chinese pages
└── index.html                 # Language selection page
```

## 🚀 Adding a New Language

### 1. Update `_data/languages.yml`

```yaml
en:
  name: "English"
  flag: "🇬🇧"

zh:
  name: "中文"
  flag: "🇨🇳"

# Add new language
fr:
  name: "Français"
  flag: "🇫🇷"
```

### 2. Add Translations to `_data/translations.yml`

```yaml
fr:
  nav_home: "Accueil"
  nav_games: "Jeux"
  hero_title: "Bienvenue à Pidan Workshop"
  # ... add all translation keys
```

### 3. Create Language Directory

```bash
mkdir fr
```

Copy the structure from `en/` or `zh/` directories.

### 4. Update `_config.yml`

```yaml
defaults:
  - scope:
      path: "fr"
    values:
      lang: "fr"
```

### 5. Update `assets/js/i18n.js`

```javascript
const SUPPORTED_LANGS = ['en', 'zh', 'fr'];
```

## 📝 Creating Translated Pages

### Page Front Matter

Each page must include:

```yaml
---
layout: default
title: "Page Title"
lang: en           # Language code
ref: unique-id     # Same across all translations
---
```

**Important**: Pages with the same `ref` value are considered translations of each other.

### Example: Creating a Translated About Page

**English** (`en/about/index.html`):
```yaml
---
layout: default
title: "About Us"
lang: en
ref: about
---
```

**Chinese** (`zh/about/index.html`):
```yaml
---
layout: default
title: "关于我们"
lang: zh
ref: about
---
```

The language switcher will automatically link these pages together.

## 🔧 Using Translations in Templates

### Basic Usage

```liquid
{% assign t = site.data.translations[page.lang] %}

<h1>{{ t.hero_title }}</h1>
<p>{{ t.hero_subtitle }}</p>
```

### With Fallback

```liquid
{% include i18n-helpers.html key="translation_key" fallback="Default Text" %}
{{ i18n_result }}
```

### Language-Specific Content

```liquid
{% if page.lang == 'en' %}
  <p>English-specific content</p>
{% elsif page.lang == 'zh' %}
  <p>中文特定内容</p>
{% endif %}
```

## 🎨 Language Switcher

The language switcher is automatically included in the header. It:

1. Detects the current page's `ref` value
2. Finds all pages with the same `ref` in other languages
3. Displays links to translated versions
4. Falls back to language home pages if no translation exists

### Customizing the Switcher

Edit `_includes/language-switcher.html` to change styling or behavior.

## 🔍 SEO Features

### Hreflang Tags

Automatically generated for all pages with translations:

```html
<link rel="alternate" hreflang="en" href="https://pidanworshop.github.io/en/about/" />
<link rel="alternate" hreflang="zh" href="https://pidanworshop.github.io/zh/about/" />
<link rel="alternate" hreflang="x-default" href="https://pidanworshop.github.io/" />
```

### Open Graph Locale

```html
<meta property="og:locale" content="en_US" />
<meta property="og:locale:alternate" content="zh_CN" />
```

### Sitemap

The sitemap includes all language versions with proper alternate links.

## 💾 Client-Side Features

### Language Detection Priority

1. **URL path** (e.g., `/en/`, `/zh/`)
2. **localStorage** (saved preference)
3. **Cookie** (cross-session persistence)
4. **Browser language** (navigator.language)

### API

```javascript
// Get current language
const lang = PidanI18n.getCurrentLanguage();

// Switch language
PidanI18n.switchLanguage('zh');

// Enable auto-redirect (optional)
PidanI18n.autoRedirect(2000); // 2 second delay

// Save preference
PidanI18n.saveLanguagePreference('en');

// Get browser language
const browserLang = PidanI18n.getBrowserLanguage();
```

### Usage Example

```html
<button onclick="PidanI18n.switchLanguage('zh')">
  切换到中文
</button>
```

## 🎯 Best Practices

### 1. Always Use `ref` for Translated Pages

```yaml
# Good
ref: about

# Bad
ref: about-en  # Don't include language in ref
```

### 2. Consistent Translation Keys

Use descriptive, hierarchical keys:

```yaml
# Good
nav_home: "Home"
nav_about: "About"
hero_title: "Welcome"
blog_read_more: "Read More"

# Bad
home: "Home"
about: "About"
title: "Welcome"
more: "Read More"
```

### 3. Handle Missing Translations

Always provide fallbacks:

```liquid
{{ t.some_key | default: "Default Text" }}
```

### 4. Test All Languages

Before deploying:
- [ ] Check all pages load in each language
- [ ] Verify language switcher works
- [ ] Test auto-detection on root page
- [ ] Validate hreflang tags with Google Search Console

## 🐛 Troubleshooting

### Language Switcher Not Working

1. Check that pages have matching `ref` values
2. Verify `lang` is set in front matter
3. Ensure `_data/languages.yml` includes the language

### Translations Not Appearing

1. Confirm key exists in `_data/translations.yml`
2. Check spelling and case sensitivity
3. Verify `page.lang` is set correctly

### SEO Tags Not Generated

1. Ensure `{% include i18n-seo.html %}` is in layout
2. Check that `site.url` is set in `_config.yml`
3. Verify pages have `ref` values

## 📊 Analytics

To track language usage:

```javascript
// Track language selection
PidanI18n.switchLanguage = (function() {
  const original = PidanI18n.switchLanguage;
  return function(lang) {
    // Your analytics code
    if (window.gtag) {
      gtag('event', 'language_switch', {
        'event_category': 'i18n',
        'event_label': lang
      });
    }
    return original.call(this, lang);
  };
})();
```

## 🚦 Performance

The i18n system is optimized for performance:

- **Static Generation**: All translations resolved at build time
- **Minimal JS**: Only 6KB of JavaScript for client-side features
- **No External Dependencies**: Pure Liquid + vanilla JavaScript
- **Lazy Loading**: Language switcher loads with page
- **Caching**: Leverages browser caching for assets

## 📚 Additional Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [HTML `lang` Attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang)
- [Hreflang Tags Guide](https://developers.google.com/search/docs/advanced/crawling/localized-versions)
- [Web Content Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 🤝 Contributing

When adding new features or pages:

1. Add all necessary translation keys to `translations.yml`
2. Create pages for all supported languages
3. Use consistent `ref` values
4. Test the language switcher
5. Update this guide if adding new i18n features

---

**Last Updated**: 2025-12-18  
**Version**: 1.0  
**Maintainer**: Pidan Workshop
