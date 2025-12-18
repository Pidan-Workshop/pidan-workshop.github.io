# I18n Implementation Test Checklist

Use this checklist to verify the internationalization implementation is working correctly.

## ✅ Pre-Deployment Tests

### 1. Language Detection
- [ ] Open root page `/` in incognito mode
- [ ] Verify the recommended language badge appears based on browser language
- [ ] Change browser language settings and refresh - badge should update

### 2. Language Switching
- [ ] Click English button from root
- [ ] Verify redirect to `/en/`
- [ ] Click language switcher in header
- [ ] Verify redirect to `/zh/`
- [ ] Check that preference is saved (refresh page, should stay in Chinese)

### 3. Language Persistence
- [ ] Switch to Chinese
- [ ] Close browser completely
- [ ] Reopen and visit root page
- [ ] Should automatically detect Chinese preference

### 4. Translation Display
- [ ] Visit `/en/` - check all text is in English
- [ ] Visit `/zh/` - check all text is in Chinese
- [ ] Verify navigation items are translated
- [ ] Check footer content is translated

### 5. SEO Tags (View Page Source)
- [ ] Visit `/en/` and view source
- [ ] Find `<link rel="alternate" hreflang="zh">`
- [ ] Find `<link rel="canonical">`
- [ ] Find `<meta property="og:locale" content="en_US">`
- [ ] Repeat for `/zh/`

### 6. Sitemap
- [ ] Visit `/sitemap.xml`
- [ ] Verify both `/en/` and `/zh/` are listed
- [ ] Check that xhtml:link alternate tags are present

### 7. Accessibility
- [ ] Use screen reader on language switcher
- [ ] Verify ARIA labels are announced correctly
- [ ] Check keyboard navigation works (Tab + Enter)

### 8. Edge Cases
- [ ] Visit `/games/sample-game/` (game page without translation)
- [ ] Language switcher should link to home pages
- [ ] Visit a blog post in one language
- [ ] If no translation exists, switcher should go to blog index

### 9. JavaScript Errors
- [ ] Open browser console (F12)
- [ ] Visit all pages
- [ ] Verify no JavaScript errors appear
- [ ] Check that `PidanI18n` object is available globally

### 10. Mobile Testing
- [ ] Test on mobile device
- [ ] Verify language switcher is accessible
- [ ] Check that touch events work
- [ ] Test both portrait and landscape

## 🧪 Browser Compatibility

Test in:
- [ ] Chrome/Edge (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

## 🔧 Development Testing

### Test Auto-Redirect (Optional)
1. Edit `index.html`
2. Uncomment: `PidanI18n.autoRedirect(2000);`
3. Clear cookies and localStorage
4. Visit root page
5. Should auto-redirect after 2 seconds

### Test JavaScript API
Open browser console and run:

```javascript
// Should return current language
PidanI18n.getCurrentLanguage()

// Should return browser's preferred language
PidanI18n.getBrowserLanguage()

// Should switch language (will reload page)
PidanI18n.switchLanguage('zh')

// Should return array ['en', 'zh']
PidanI18n.SUPPORTED_LANGS
```

### Test Cookie Storage
```javascript
// Check cookie is set
document.cookie.split('; ').find(row => row.startsWith('pidan_lang='))

// Check localStorage
localStorage.getItem('pidan_lang')
```

## 🚨 Common Issues

### Language Switcher Not Visible
- Check that `{% include language-switcher.html %}` is in header
- Verify CSS for `.language-switcher` exists

### Translations Not Working
- Verify `_data/translations.yml` syntax is correct
- Check that `page.lang` is set in front matter
- Confirm translation keys match

### SEO Tags Missing
- Ensure `{% include i18n-seo.html %}` is in layout head
- Check that `site.url` is set in `_config.yml`

### Auto-Redirect Not Working
- Check browser console for errors
- Verify `i18n.js` is loaded before script that calls `autoRedirect`

## 📊 Analytics to Track

Once deployed, monitor:
1. Language distribution (EN vs ZH visitors)
2. Language switch events
3. Root page bounce rate (if high, consider enabling auto-redirect)
4. Pages with high exit rates in specific languages

## ✅ Production Verification

After deploying to GitHub Pages:
- [ ] Visit https://pidanworshop.github.io
- [ ] Test all above scenarios
- [ ] Check Google Search Console for hreflang validation
- [ ] Verify sitemap is indexed
- [ ] Monitor for crawl errors

## 🎉 Success Criteria

The i18n implementation is successful when:
- ✅ Users can easily switch languages
- ✅ Language preference is remembered
- ✅ Search engines can discover all language versions
- ✅ All UI text is properly translated
- ✅ No JavaScript errors in console
- ✅ Accessible to screen reader users
- ✅ Works across all major browsers

---

**Test Date**: _____________  
**Tested By**: _____________  
**Result**: ⬜ Pass  ⬜ Fail  
**Notes**: _________________
