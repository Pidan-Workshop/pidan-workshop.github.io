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

    // Handle More Information details element smooth animation
    const moreInfoDetails = document.querySelectorAll('.more-info-details');
    
    moreInfoDetails.forEach(details => {
        const summary = details.querySelector('.more-info-summary');
        const content = details.querySelector('.more-info-content');
        
        if (!summary || !content) return;
        
        // Smooth open/close animation
        details.addEventListener('toggle', function(e) {
            if (this.open) {
                // Opening
                content.style.maxHeight = content.scrollHeight + 'px';
                content.style.opacity = '1';
            } else {
                // Closing
                content.style.maxHeight = '0px';
                content.style.opacity = '0';
            }
        });
        
        // Initialize styles
        if (!details.open) {
            content.style.maxHeight = '0px';
            content.style.opacity = '0';
        } else {
            content.style.maxHeight = content.scrollHeight + 'px';
            content.style.opacity = '1';
        }
    });
