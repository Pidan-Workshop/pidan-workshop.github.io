/**
 * Game Detail Page Script
 */

// 全屏切换函数
function toggleGameFullscreen() {
    const gameDisplay = document.querySelector('.game-display');
    if (!gameDisplay) {
        console.error('Game display container not found');
        return;
    }
    
    // 检查是否已经在全屏状态
    const isCurrentlyFullscreen = document.fullscreenElement === gameDisplay ||
                                  document.webkitFullscreenElement === gameDisplay ||
                                  document.mozFullScreenElement === gameDisplay ||
                                  document.msFullscreenElement === gameDisplay;
    
    if (!isCurrentlyFullscreen) {
        // 请求全屏
        if (gameDisplay.requestFullscreen) {
            gameDisplay.requestFullscreen().catch(err => {
                console.error('Fullscreen request failed:', err);
            });
        } else if (gameDisplay.webkitRequestFullscreen) {
            gameDisplay.webkitRequestFullscreen();
        } else if (gameDisplay.mozRequestFullScreen) {
            gameDisplay.mozRequestFullScreen();
        } else if (gameDisplay.msRequestFullscreen) {
            gameDisplay.msRequestFullscreen();
        } else {
            console.warn('Fullscreen API not supported');
        }
    } else {
        // 退出全屏
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {

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
});