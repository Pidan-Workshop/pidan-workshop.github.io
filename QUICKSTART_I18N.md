# 🚀 I18n Quick Start Guide

**Get started with the internationalization system in 5 minutes.**

---

## 📋 Prerequisites

- Jekyll site is running locally
- Basic understanding of Liquid templates
- Two languages already set up: English (en) and Chinese (zh)

---

## ⚡ Quick Test (2 minutes)

### 1. Start Jekyll
```bash
bundle exec jekyll serve
```

### 2. Test Language Selection
1. Open browser: http://localhost:4000
2. You'll see language selection page
3. Click "English" or "中文"
4. Notice the "Recommended" badge on your browser's language

### 3. Test Language Switching
1. Look for language switcher in header (🇬🇧 or 🇨🇳)
2. Click it to switch languages
3. Refresh page - should stay in selected language
4. Open in new tab - preference is remembered!

### 4. Verify SEO Tags
1. Right-click page → "View Page Source"
2. Search for: `hreflang` - should find alternate language links
3. Search for: `canonical` - should find canonical URL
4. Search for: `og:locale` - should find locale tag

✅ **If all above work, your i18n system is ready!**

---

## 🎨 Common Tasks

### Add a New Translation Key

**File:** `_data/translations.yml`

```yaml
en:
  my_new_key: "Hello World"
  
zh:
  my_new_key: "你好世界"
```

**Usage in template:**
```liquid
{% assign t = site.data.translations[page.lang] %}
{{ t.my_new_key }}
```

### Create a Translated Page

**English:** `en/contact/index.html`
```yaml
---
layout: default
title: "Contact Us"
lang: en
ref: contact    # Important: same ref for all translations
---

{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.contact_title }}</h1>
```

**Chinese:** `zh/contact/index.html`
```yaml
---
layout: default
title: "联系我们"
lang: zh
ref: contact    # Same ref as English version
---

{% assign t = site.data.translations[page.lang] %}
<h1>{{ t.contact_title }}</h1>
```

**Add translations:**
```yaml
en:
  contact_title: "Get in Touch"
  
zh:
  contact_title: "联系我们"
```

### Enable Auto-Redirect (Optional)

**File:** `index.html`

Uncomment this line:
```javascript
// PidanI18n.autoRedirect(2000);
PidanI18n.autoRedirect(2000); // Now active!
```

This will auto-redirect users to their preferred language after 2 seconds.

---

## 🧪 Quick Tests

### Test 1: Language Persistence
```
1. Visit site
2. Switch to Chinese
3. Close browser completely
4. Reopen and visit site
Expected: Should remember Chinese preference
```

### Test 2: SEO Tags
```
1. View page source
2. Find: <link rel="alternate" hreflang="zh" href="/zh/">
Expected: Should exist for all pages with translations
```

### Test 3: JavaScript API
```
Open console (F12) and run:
> PidanI18n.getCurrentLanguage()
Expected: Returns 'en' or 'zh'

> PidanI18n.SUPPORTED_LANGS
Expected: Returns ['en', 'zh']
```

---

## 🐛 Common Issues & Fixes

### Issue: Language switcher not visible
**Fix:** Check that header includes the component:
```liquid
{% include language-switcher.html %}
```

### Issue: Translations not showing
**Fix:** Verify front matter has `lang` set:
```yaml
---
lang: en
---
```

### Issue: Pages not linked by language switcher
**Fix:** Ensure both pages have same `ref`:
```yaml
# en/about/index.html
ref: about

# zh/about/index.html
ref: about
```

### Issue: JavaScript errors in console
**Fix:** Check i18n.js is loaded:
```html
<script src="/assets/js/i18n.js"></script>
```

---

## 📚 Learn More

| Topic | Document | Reading Time |
|-------|----------|--------------|
| Complete Guide | `I18N_GUIDE.md` | 15 min |
| Testing | `I18N_TEST.md` | 10 min |
| Architecture | `I18N_IMPLEMENTATION_SUMMARY.md` | 10 min |
| Status | `IMPLEMENTATION_COMPLETE.md` | 5 min |

---

## 🎯 Next Steps

1. ✅ Read this guide (you're here!)
2. 📖 Skim `I18N_GUIDE.md` for detailed info
3. 🧪 Run tests from `I18N_TEST.md`
4. 🚀 Deploy and monitor

---

## 💡 Pro Tips

### Tip 1: Consistent Naming
```yaml
# Good
nav_home: "Home"
nav_about: "About"
hero_title: "Welcome"

# Bad
home: "Home"
about_link: "About"
title: "Welcome"
```

### Tip 2: Always Use `ref`
Every translated page needs the same `ref` value to be linked together.

### Tip 3: Test Both Languages
After adding a feature, always test in both English and Chinese.

### Tip 4: Check Console
Keep browser console open during development to catch errors early.

---

## 🆘 Need Help?

1. **Check documentation**: Start with `I18N_GUIDE.md`
2. **Review examples**: Look at existing pages in `en/` and `zh/`
3. **Console debugging**: Check browser console for error messages
4. **Test checklist**: Use `I18N_TEST.md` to diagnose issues

---

## ✨ Quick Reference

### JavaScript API
```javascript
PidanI18n.getCurrentLanguage()        // Get current language
PidanI18n.switchLanguage('zh')        // Switch to Chinese
PidanI18n.getBrowserLanguage()        // Get browser language
PidanI18n.autoRedirect(2000)          // Auto-redirect (2s delay)
PidanI18n.SUPPORTED_LANGS             // ['en', 'zh']
```

### Liquid Variables
```liquid
{% assign t = site.data.translations[page.lang] %}  # Load translations
{{ t.key_name }}                                    # Use translation
{{ page.lang }}                                     # Current language
{% if page.lang == 'en' %}...{% endif %}           # Conditional
```

### Front Matter
```yaml
---
layout: default
title: "Page Title"
lang: en           # Required: language code
ref: unique-id     # Required: for linking translations
---
```

---

## 🎉 Success!

You're now ready to use the i18n system!

**Remember:**
- Always set `lang` and `ref` in front matter
- Add translations to `_data/translations.yml`
- Test in both languages
- Check SEO tags in page source

**Happy internationalizing!** 🌍

---

**Quick Start Version**: 1.0  
**Last Updated**: 2025-12-18  
**Estimated Time**: 5 minutes
