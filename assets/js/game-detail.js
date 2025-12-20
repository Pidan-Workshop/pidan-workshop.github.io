/**
 * Game Detail Page Script
 */

document.addEventListener('DOMContentLoaded', function() {
    const fullscreenBtns = document.querySelectorAll('.fullscreen-btn');
    
    fullscreenBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const targetSelector = this.getAttribute('data-target');
            const targetElement = document.querySelector('.' + targetSelector);
            
            if (!targetElement) return;
            
            if (targetElement.requestFullscreen) {
                targetElement.requestFullscreen().catch(err => {
                    console.error('Unable to enter fullscreen:', err.message);
                });
            } else if (targetElement.webkitRequestFullscreen) {
                // Safari
                targetElement.webkitRequestFullscreen();
            } else if (targetElement.msRequestFullscreen) {
                // IE11
                targetElement.msRequestFullscreen();
            }
        });
    });
});
