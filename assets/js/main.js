// Main JavaScript for Pidan Workshop

document.addEventListener('DOMContentLoaded', function() {
    console.log('Pidan Workshop - Loaded');
    
    // Language preference management
    const currentLang = document.documentElement.lang || 'en';
    const savedLang = localStorage.getItem('preferredLanguage');
    
    // Save current language preference
    if (currentLang && !savedLang) {
        localStorage.setItem('preferredLanguage', currentLang);
    }
    
    // Save language preference when clicking language switcher
    document.querySelectorAll('.language-switcher .lang-link').forEach(link => {
        link.addEventListener('click', function() {
            const targetLang = this.getAttribute('lang');
            if (targetLang) {
                localStorage.setItem('preferredLanguage', targetLang);
            }
        });
    });
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add active class to current navigation item
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.main-nav a');
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath || 
            currentPath.startsWith(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
});

// Lazy load images
if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (img.dataset.src) {
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                    observer.unobserve(img);
                }
            }
        });
    });
    
    document.querySelectorAll('img[data-src]').forEach(img => {
        imageObserver.observe(img);
    });
}
