# I18n Testing Checklist

## Pre-Deployment Testing

### ✅ Core Functionality

#### Language Detection
- [ ] Visit root page (/) - auto-detects browser language
- [ ] Clear localStorage - should detect fresh each time
- [ ] Test with browser set to Chinese (zh-CN, zh-TW, etc.)
- [ ] Test with browser set to English (en-US, en-GB, etc.)
- [ ] Test with unsupported language (should default to English)

#### Language Persistence
- [ ] Select English on root page
- [ ] Check localStorage: `localStorage.getItem('preferredLanguage')` === 'en'
- [ ] Close browser, reopen - should remember English preference
- [ ] Switch to Chinese
- [ ] Check localStorage: `localStorage.getItem('preferredLanguage')` === 'zh'
- [ ] Close browser, reopen - should remember Chinese preference

#### Auto-Redirect
- [ ] Visit root page, don't move mouse - redirects after 3 seconds
- [ ] Visit root page, move mouse - redirect cancels
- [ ] Visit root page, tap screen (mobile) - redirect cancels

### ✅ Navigation & Switching

#### Language Switcher
- [ ] Switcher visible on all pages
- [ ] Switcher shows correct flag and language name
- [ ] Click switcher on homepage (/en/ or /zh/)
- [ ] Click switcher on /about/ page
- [ ] Click switcher on /games/ page
- [ ] Click switcher on /products/ page
- [ ] Click switcher on /blog/ page

#### Page-to-Page Switching
- [ ] On /en/about/, click 🇨🇳 → goes to /zh/about/
- [ ] On /zh/about/, click 🇬🇧 → goes to /en/about/
- [ ] On /en/games/, click 🇨🇳 → goes to /zh/games/
- [ ] On /zh/games/, click 🇬🇧 → goes to /en/games/
- [ ] On page without translation → goes to homepage in target language

### ✅ Content Display

#### Translation Keys
- [ ] Homepage hero title displays correctly in both languages
- [ ] Navigation menu items translated correctly
- [ ] About page content all translated
- [ ] Products page content all translated
- [ ] Blog page content all translated
- [ ] Games page content all translated
- [ ] Footer content translated

#### No Hardcoded Text
- [ ] Search for "Home" in English pages → only in translations.yml
- [ ] Search for "首页" in Chinese pages → only in translations.yml
- [ ] No placeholder text like "[Translation Missing]"
- [ ] All UI buttons have correct labels

### ✅ SEO & Meta Tags

#### Alternate Language Tags
- [ ] View page source on /en/about/
- [ ] Should see: `<link rel="alternate" hreflang="en" ... />`
- [ ] Should see: `<link rel="alternate" hreflang="zh" ... />`
- [ ] Should see: `<link rel="alternate" hreflang="x-default" ... />`
- [ ] All hreflang URLs are absolute (include domain)

#### HTML Lang Attribute
- [ ] English pages have `<html lang="en">`
- [ ] Chinese pages have `<html lang="zh">`
- [ ] Root page has appropriate lang attribute

### ✅ Mobile & Responsive

#### Mobile Layout
- [ ] Language selector visible on mobile
- [ ] Language flags readable on small screens
- [ ] Auto-redirect works on mobile
- [ ] Touch interaction cancels redirect
- [ ] Language switcher easily tappable

### ✅ Edge Cases

#### Browser Compatibility
- [ ] Works in Chrome/Edge
- [ ] Works in Firefox
- [ ] Works in Safari (if available)
- [ ] Works in mobile browsers

#### localStorage Scenarios
- [ ] Works in incognito/private mode
- [ ] Handles localStorage disabled gracefully
- [ ] Multiple tabs maintain same preference

#### URL Direct Access
- [ ] Can directly visit /en/about/
- [ ] Can directly visit /zh/about/
- [ ] Can directly visit /en/games/
- [ ] Language persists when using direct URLs

## Development Testing

### ✅ File Structure

#### Data Files
- [ ] `_data/languages.yml` exists and valid YAML
- [ ] `_data/translations.yml` exists and valid YAML
- [ ] All translation keys present in both en: and zh:
- [ ] No duplicate keys

#### Include Files
- [ ] `_includes/language-switcher.html` exists
- [ ] `_includes/alternate-languages.html` exists
- [ ] `_includes/i18n-helper.html` exists
- [ ] All includes referenced correctly in layouts

#### Page Files
- [ ] All /en/ pages have `lang: en`
- [ ] All /zh/ pages have `lang: zh`
- [ ] Matching pages have same `ref` value
- [ ] All pages use `{% assign t = ... %}`

### ✅ Code Quality

#### Liquid Templates
- [ ] No liquid syntax errors
- [ ] All variables properly assigned
- [ ] Translation keys correctly referenced
- [ ] Comments explain complex logic

#### JavaScript
- [ ] No console errors on any page
- [ ] localStorage operations don't throw errors
- [ ] Event listeners properly attached
- [ ] Code runs on page load

#### YAML Syntax
- [ ] All YAML files properly indented
- [ ] Quotes used consistently
- [ ] Special characters properly escaped
- [ ] Multi-line text formatted correctly

## Performance Testing

### ✅ Load Times
- [ ] Pages load in < 2 seconds
- [ ] Language detection doesn't delay page load
- [ ] No blocking JavaScript
- [ ] CSS doesn't cause layout shifts

### ✅ JavaScript Performance
- [ ] localStorage reads are fast (< 1ms)
- [ ] No memory leaks
- [ ] Event listeners cleaned up properly

## Documentation Testing

### ✅ Documentation Files
- [ ] `I18N_GUIDE.md` exists and complete
- [ ] `I18N_QUICKSTART.md` exists and clear
- [ ] `I18N_ARCHITECTURE.md` exists and accurate
- [ ] `I18N_TESTING_CHECKLIST.md` (this file!) exists
- [ ] `IMPLEMENTATION_SUMMARY.md` exists
- [ ] `README.md` updated with i18n section

### ✅ Documentation Accuracy
- [ ] Code examples in docs are correct
- [ ] File paths in docs are accurate
- [ ] Instructions can be followed successfully
- [ ] Links in docs work (if any)

## Accessibility Testing

### ✅ Accessibility
- [ ] Language switcher has proper ARIA labels
- [ ] Flag emojis have text alternatives
- [ ] Keyboard navigation works
- [ ] Screen reader announces language changes
- [ ] Links have descriptive text

## Security Testing

### ✅ Security
- [ ] No XSS vulnerabilities in language parameter
- [ ] localStorage doesn't store sensitive data
- [ ] No eval() or unsafe JavaScript
- [ ] External links have `rel="noopener"`

## Final Verification

### ✅ Pre-Commit Checklist
- [ ] All files saved
- [ ] No syntax errors in any file
- [ ] Jekyll builds successfully: `bundle exec jekyll build`
- [ ] Jekyll serves locally: `bundle exec jekyll serve`
- [ ] Visited all major pages locally
- [ ] Tested language switching thoroughly
- [ ] Cleared localStorage and retested
- [ ] No console errors or warnings

### ✅ Git Commit Checklist
- [ ] Meaningful commit message
- [ ] All new files added to git
- [ ] No unnecessary files included
- [ ] .gitignore respected

### ✅ Post-Deploy Checklist
- [ ] Site builds on GitHub Pages
- [ ] All pages accessible
- [ ] Language switching works in production
- [ ] SEO tags visible in production
- [ ] No 404 errors
- [ ] Performance acceptable

## Regression Testing (Future)

When making changes, re-test:
- [ ] Language detection still works
- [ ] Preference persistence still works
- [ ] Language switching on all pages
- [ ] New translations added correctly
- [ ] No broken links introduced

## Known Issues / Limitations

Document any issues found:

1. Issue: _______________________
   Status: _____________________
   Workaround: _________________

2. Issue: _______________________
   Status: _____________________
   Workaround: _________________

## Testing Notes

**Environment:**
- OS: _________________
- Browser: ____________
- Jekyll Version: _____
- Test Date: __________

**Test Results:**
- Pass: _____ / _____
- Fail: _____ / _____
- Skip: _____ / _____

**Issues Found:**
1. _________________________
2. _________________________
3. _________________________

**Tester Signature:** _______________

---

**Status:** Ready for Production ✅
**Last Updated:** 2025-12-18
