/**
 * I18n JavaScript Module for Pidan Workshop
 * Handles language detection, persistence, and switching
 */

const PidanI18n = (function() {
    'use strict';
    
    const STORAGE_KEY = 'pidan_lang';
    const COOKIE_NAME = 'pidan_lang';
    const SUPPORTED_LANGS = ['en', 'zh'];
    const DEFAULT_LANG = 'en';
    
    /**
     * Get browser's preferred language
     */
    function getBrowserLanguage() {
        const lang = navigator.language || navigator.userLanguage;
        const langCode = lang.toLowerCase().split('-')[0];
        
        // Check if browser language is supported
        if (SUPPORTED_LANGS.includes(langCode)) {
            return langCode;
        }
        
        // Check for Chinese variants
        if (lang.toLowerCase().startsWith('zh')) {
            return 'zh';
        }
        
        return DEFAULT_LANG;
    }
    
    /**
     * Get language from cookie
     */
    function getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) {
            return parts.pop().split(';').shift();
        }
        return null;
    }
    
    /**
     * Set language cookie
     */
    function setCookie(name, value, days = 365) {
        const date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        const expires = `expires=${date.toUTCString()}`;
        document.cookie = `${name}=${value};${expires};path=/;SameSite=Lax`;
    }
    
    /**
     * Get current language from various sources
     */
    function getCurrentLanguage() {
        // 1. Check URL path
        const pathLang = window.location.pathname.split('/')[1];
        if (SUPPORTED_LANGS.includes(pathLang)) {
            return pathLang;
        }
        
        // 2. Check localStorage
        const storedLang = localStorage.getItem(STORAGE_KEY);
        if (storedLang && SUPPORTED_LANGS.includes(storedLang)) {
            return storedLang;
        }
        
        // 3. Check cookie
        const cookieLang = getCookie(COOKIE_NAME);
        if (cookieLang && SUPPORTED_LANGS.includes(cookieLang)) {
            return cookieLang;
        }
        
        // 4. Use browser language
        return getBrowserLanguage();
    }
    
    /**
     * Save language preference
     */
    function saveLanguagePreference(lang) {
        if (!SUPPORTED_LANGS.includes(lang)) {
            console.warn(`Unsupported language: ${lang}`);
            return;
        }
        
        localStorage.setItem(STORAGE_KEY, lang);
        setCookie(COOKIE_NAME, lang);
    }
    
    /**
     * Get translated URL for current page
     */
    function getTranslatedUrl(targetLang) {
        const currentPath = window.location.pathname;
        const currentLang = getCurrentLanguage();
        
        if (currentLang === targetLang) {
            return currentPath;
        }
        
        // Replace language in path
        if (currentPath.startsWith(`/${currentLang}/`)) {
            return currentPath.replace(`/${currentLang}/`, `/${targetLang}/`);
        }
        
        // Default to home page of target language
        return `/${targetLang}/`;
    }
    
    /**
     * Switch to a different language
     */
    function switchLanguage(targetLang) {
        if (!SUPPORTED_LANGS.includes(targetLang)) {
            console.error(`Invalid language: ${targetLang}`);
            return;
        }
        
        saveLanguagePreference(targetLang);
        const newUrl = getTranslatedUrl(targetLang);
        window.location.href = newUrl;
    }
    
    /**
     * Auto-redirect based on language preference
     */
    function autoRedirect(delay = 0) {
        const currentPath = window.location.pathname;
        
        // Don't redirect if already on a language-specific page
        if (SUPPORTED_LANGS.some(lang => currentPath.startsWith(`/${lang}/`))) {
            return;
        }
        
        // Only redirect from root
        if (currentPath !== '/' && currentPath !== '/index.html') {
            return;
        }
        
        const preferredLang = getCurrentLanguage();
        const targetUrl = `/${preferredLang}/`;
        
        if (delay > 0) {
            setTimeout(() => {
                window.location.href = targetUrl;
            }, delay);
        } else {
            window.location.href = targetUrl;
        }
    }
    
    /**
     * Initialize language switching functionality
     */
    function init() {
        // Save current language if on a language-specific page
        const currentLang = getCurrentLanguage();
        const pathLang = window.location.pathname.split('/')[1];
        
        if (SUPPORTED_LANGS.includes(pathLang)) {
            saveLanguagePreference(pathLang);
        }
        
        // Bind language switcher events
        document.querySelectorAll('[data-lang-switch]').forEach(element => {
            element.addEventListener('click', function(e) {
                e.preventDefault();
                const targetLang = this.getAttribute('data-lang-switch') || 
                                  this.getAttribute('lang');
                if (targetLang) {
                    switchLanguage(targetLang);
                }
            });
        });
        
        // Log current language for debugging
        console.log('Current language:', currentLang);
    }
    
    // Public API
    return {
        init,
        getCurrentLanguage,
        switchLanguage,
        autoRedirect,
        saveLanguagePreference,
        getBrowserLanguage,
        SUPPORTED_LANGS,
        DEFAULT_LANG
    };
})();

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', PidanI18n.init);
} else {
    PidanI18n.init();
}
