# I18n Quick Start Guide

## 🚀 5-Minute Overview

### What Changed?

Your site now has a **mature internationalization system** with:
- ✅ Automatic language detection
- ✅ User preference memory (localStorage)
- ✅ SEO-optimized with hreflang tags
- ✅ Centralized translations
- ✅ Easy to add new languages

### Key Files

```
_data/translations.yml    → All UI text translations
_data/languages.yml       → Language metadata
I18N_GUIDE.md            → Complete documentation
```

## 📝 Common Tasks

### 1. Add a New Translation

**Edit `_data/translations.yml`:**

```yaml
en:
  my_new_text: "Hello World"
  
zh:
  my_new_text: "你好世界"
```

**Use in templates:**

```liquid
{% assign t = site.data.translations[page.lang] %}
{{ t.my_new_text }}
```

### 2. Create a New Page

**File: `en/my-page/index.html`**
```yaml
---
layout: default
title: My Page
lang: en
ref: my-page
---

{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.my_page_title }}</h1>
```

**File: `zh/my-page/index.html`**
```yaml
---
layout: default
title: 我的页面
lang: zh
ref: my-page  # Same as English!
---

{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.my_page_title }}</h1>
```

### 3. Add a Third Language (e.g., French)

#### Step 1: Add to `_data/languages.yml`
```yaml
fr:
  name: "Français"
  flag: "🇫🇷"
```

#### Step 2: Add to `_data/translations.yml`
```yaml
fr:
  nav_home: "Accueil"
  nav_games: "Jeux"
  # ... copy all keys from en or zh
```

#### Step 3: Update `_config.yml`
```yaml
defaults:
  - scope:
      path: "fr"
    values:
      lang: "fr"
```

#### Step 4: Create `/fr/` directory
Copy structure from `/en/` or `/zh/`

#### Step 5: Update root `index.html`
Add French button to language selector

## 🎯 Best Practices

### ✅ DO
- Use descriptive translation keys: `about_mission_text`
- Keep same `ref` across translated pages
- Test language switching on all pages
- Check localStorage persistence

### ❌ DON'T
- Hardcode text in templates
- Use generic keys like `text1`, `text2`
- Forget to add translations for new keys
- Skip the `ref` attribute in page front matter

## 🔍 Testing

### Local Testing
```bash
bundle exec jekyll serve
```

Visit `http://localhost:4000` and test:
1. Language auto-detection (clear localStorage first)
2. Language switching on different pages
3. localStorage persistence (switch, close, reopen)
4. View page source for hreflang tags

### Clear localStorage (for testing)
Browser Console:
```javascript
localStorage.clear();
location.reload();
```

## 📚 Need More Help?

- **Quick Reference:** See `README.md` section 🌍 Internationalization
- **Detailed Guide:** Read `I18N_GUIDE.md` for everything
- **Implementation:** Check `IMPLEMENTATION_SUMMARY.md` for what changed

## 🐛 Troubleshooting

**Language switcher not showing?**
- Check `_includes/language-switcher.html` is included in header
- Verify `_data/languages.yml` exists and is valid

**Translations not working?**
- Check YAML syntax in `translations.yml`
- Verify key exists for current language
- Use `{% assign t = site.data.translations[page.lang] %}` at top of page

**Language not persisting?**
- Check browser localStorage is enabled
- Verify `assets/js/main.js` is loaded
- Check browser console for JavaScript errors

**SEO links missing?**
- Verify `_includes/alternate-languages.html` exists
- Check it's included in `_layouts/default.html`
- Ensure pages have matching `ref` values

---

**Ready to go!** Your i18n system is complete and production-ready. 🎉
