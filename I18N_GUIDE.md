# Internationalization (i18n) Guide

## Overview

This site implements a comprehensive internationalization system that supports multiple languages with automatic detection, SEO optimization, and user preference persistence.

## System Architecture

### 1. Directory Structure

```
├── _data/
│   ├── languages.yml      # Language metadata (name, flag)
│   └── translations.yml   # All text translations
├── _includes/
│   ├── language-switcher.html       # UI component for switching languages
│   ├── alternate-languages.html     # SEO alternate links
│   └── i18n-helper.html            # Helper functions
├── en/                    # English pages
│   ├── index.html
│   ├── games/
│   ├── products/
│   ├── blog/
│   └── about/
├── zh/                    # Chinese pages
│   └── [same structure]
└── index.html            # Language selector landing page
```

### 2. Key Features

#### Browser Language Detection
- Automatically detects user's browser language on first visit
- Falls back to English if language not supported
- Implemented in root `index.html`

#### Language Preference Persistence
- Saves user's language choice in localStorage
- Remembers preference across sessions
- Implemented in `assets/js/main.js`

#### SEO Optimization
- Adds `hreflang` alternate links for all page translations
- Helps search engines understand content relationships
- Implemented in `_includes/alternate-languages.html`

#### Intelligent Language Switcher
- Links to translated version of current page
- Falls back to homepage if translation doesn't exist
- Implemented in `_includes/language-switcher.html`

## Usage Guide

### Creating a New Page

1. **Create English version** in `/en/directory/`:
   ```yaml
   ---
   layout: default
   title: Page Title
   lang: en
   ref: unique-page-id
   ---
   ```

2. **Create translated versions** in other language directories:
   ```yaml
   ---
   layout: default
   title: 页面标题
   lang: zh
   ref: unique-page-id  # MUST match English version
   ---
   ```

3. **Use translations in content**:
   ```liquid
   {% assign t = site.data.translations[page.lang] %}
   <h1>{{ t.page_title }}</h1>
   ```

### Adding Translations

Edit `_data/translations.yml`:

```yaml
en:
  my_new_key: "English text"
  
zh:
  my_new_key: "中文文本"
```

### Adding a New Language

#### Step 1: Add Language Metadata

Edit `_data/languages.yml`:
```yaml
fr:
  name: "Français"
  flag: "🇫🇷"
```

#### Step 2: Add Translations

Edit `_data/translations.yml`:
```yaml
fr:
  nav_home: "Accueil"
  nav_games: "Jeux"
  # ... copy all keys from en: or zh:
```

#### Step 3: Configure Jekyll

Edit `_config.yml`:
```yaml
defaults:
  - scope:
      path: "_posts/fr"
      type: "posts"
    values:
      lang: "fr"
      layout: "post"
  - scope:
      path: "fr"
    values:
      lang: "fr"
```

#### Step 4: Create Page Structure

Create `/fr/` directory with the same structure as `/en/`:
```
fr/
├── index.html
├── games/
│   └── index.html
├── products/
│   └── index.html
├── blog/
│   └── index.html
└── about/
    └── index.html
```

#### Step 5: Update Language Selector

Edit root `index.html` to add the new language option:
```html
<a href="/fr/" class="lang-btn">
    <span class="flag">🇫🇷</span>
    <span class="lang-name">Français</span>
</a>
```

## Best Practices

### 1. Consistent `ref` Values
Always use the same `ref` value for translated pages:
```yaml
# en/about/index.html
ref: about

# zh/about/index.html  
ref: about  # Same value!
```

### 2. Translation Keys Naming
Use descriptive, hierarchical keys:
```yaml
# Good
nav_home: "Home"
hero_title: "Welcome"
about_mission: "Our Mission"

# Avoid
home: "Home"
title: "Welcome"
mission: "Our Mission"
```

### 3. Date Formatting
Use appropriate date formats per language:
```liquid
{% if page.lang == 'en' %}
  {{ post.date | date: "%B %d, %Y" }}
{% elsif page.lang == 'zh' %}
  {{ post.date | date: "%Y年%m月%d日" }}
{% endif %}
```

### 4. Testing Translations
Always check:
- [ ] All translation keys exist in all languages
- [ ] `ref` values match across translated pages
- [ ] Language switcher links work correctly
- [ ] Date formats are appropriate
- [ ] No hardcoded text in templates

## Advanced Features

### Fallback Translations

The `i18n-helper.html` include provides automatic fallback to English:

```liquid
{% include i18n-helper.html key="some_key" %}
```

If the key doesn't exist in the current language, it will use the English version.

### Conditional Content

Show different content based on language:

```liquid
{% if page.lang == 'en' %}
  <p>English-only content</p>
{% elsif page.lang == 'zh' %}
  <p>中文专属内容</p>
{% endif %}
```

### Dynamic Language Links

Generate links that preserve language context:

```liquid
<a href="/{{ page.lang }}/games/">{{ t.nav_games }}</a>
```

## Troubleshooting

### Language Switcher Not Working
- Check that `ref` values match across translated pages
- Verify page is in `site.pages` collection
- Ensure `lang` is set in front matter

### Translations Not Showing
- Verify key exists in `_data/translations.yml`
- Check for typos in key names
- Ensure `page.lang` is properly set

### SEO Issues
- Verify `alternate-languages.html` is included in layout
- Check that `site.url` is set in `_config.yml`
- Ensure pages have matching `ref` values

## Future Enhancements

Potential improvements for the i18n system:

1. **Automatic Translation Validation**
   - Script to check for missing translation keys
   - Report on untranslated content

2. **Language-Specific Content Types**
   - Custom collections per language
   - Language-aware permalinks

3. **Translation Management**
   - Web interface for managing translations
   - Export/import functionality for translators

4. **Additional Languages**
   - Japanese (ja)
   - Korean (ko)
   - Spanish (es)
   - German (de)

## Resources

- [Jekyll Internationalization](https://jekyllrb.com/docs/step-by-step/10-internationalization/)
- [Google Multilingual Sites Guidelines](https://developers.google.com/search/docs/advanced/crawling/managing-multi-regional-sites)
- [W3C Internationalization Best Practices](https://www.w3.org/International/questions/qa-html-language-declarations)

---

**Questions?** Open an issue on GitHub or contact the maintainers.
