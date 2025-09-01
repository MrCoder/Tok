// DictaFlow.ai Website JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeNavigation();
    initializeSmoothScrolling();
    initializeTypingAnimation();
    initializeScrollEffects();
    initializeMobileMenu();
});

// Navigation functionality
function initializeNavigation() {
    const header = document.querySelector('.header');
    
    // Add scroll effect to header
    window.addEventListener('scroll', function() {
        if (window.scrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });
}

// Smooth scrolling for anchor links
function initializeSmoothScrolling() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                const offsetTop = targetElement.offsetTop - 80; // Account for fixed header
                
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// Typing animation for demo text
function initializeTypingAnimation() {
    const typingElement = document.querySelector('.typing-text');
    if (!typingElement) return;
    
    const texts = [
        "This is an example of real-time voice transcription...",
        "Press and hold your hotkey to start recording your voice...",
        "DictaFlow converts speech to text instantly with AI enhancement...",
        "Works in any application - emails, documents, chat apps..."
    ];
    
    let currentTextIndex = 0;
    let currentCharIndex = 0;
    let isDeleting = false;
    
    function typeText() {
        const currentText = texts[currentTextIndex];
        
        if (!isDeleting) {
            // Typing
            typingElement.textContent = currentText.substring(0, currentCharIndex + 1);
            currentCharIndex++;
            
            if (currentCharIndex === currentText.length) {
                // Pause before deleting
                setTimeout(() => {
                    isDeleting = true;
                }, 2000);
            }
        } else {
            // Deleting
            typingElement.textContent = currentText.substring(0, currentCharIndex - 1);
            currentCharIndex--;
            
            if (currentCharIndex === 0) {
                isDeleting = false;
                currentTextIndex = (currentTextIndex + 1) % texts.length;
            }
        }
        
        const typingSpeed = isDeleting ? 50 : 100;
        setTimeout(typeText, typingSpeed);
    }
    
    // Start typing animation
    setTimeout(typeText, 1000);
}

// Scroll effects and animations
function initializeScrollEffects() {
    // Intersection Observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    const animateElements = document.querySelectorAll('.feature-card, .step, .section-header');
    animateElements.forEach(el => {
        observer.observe(el);
    });
    
    // Add CSS for animations
    addAnimationStyles();
}

// Mobile menu functionality
function initializeMobileMenu() {
    const navToggle = document.querySelector('.nav-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (navToggle && navMenu) {
        navToggle.addEventListener('click', function() {
            navToggle.classList.toggle('active');
            navMenu.classList.toggle('active');
        });
        
        // Close menu when clicking on a link
        const navLinks = document.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                navToggle.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });
    }
}

// Add animation styles dynamically
function addAnimationStyles() {
    const styles = `
        .feature-card,
        .step,
        .section-header {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.6s ease;
        }
        
        .feature-card.animate-in,
        .step.animate-in,
        .section-header.animate-in {
            opacity: 1;
            transform: translateY(0);
        }
        
        .header.scrolled {
            background: rgba(255, 255, 255, 0.98);
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        @media (max-width: 768px) {
            .nav-menu {
                position: fixed;
                top: 73px;
                left: -100%;
                width: 100%;
                height: calc(100vh - 73px);
                background: rgba(255, 255, 255, 0.98);
                backdrop-filter: blur(10px);
                flex-direction: column;
                justify-content: flex-start;
                align-items: center;
                padding-top: 2rem;
                transition: left 0.3s ease;
                border-top: 1px solid var(--border-color);
            }
            
            .nav-menu.active {
                left: 0;
            }
            
            .nav-toggle.active span:nth-child(1) {
                transform: rotate(45deg) translate(5px, 5px);
            }
            
            .nav-toggle.active span:nth-child(2) {
                opacity: 0;
            }
            
            .nav-toggle.active span:nth-child(3) {
                transform: rotate(-45deg) translate(7px, -6px);
            }
        }
    `;
    
    const styleSheet = document.createElement('style');
    styleSheet.textContent = styles;
    document.head.appendChild(styleSheet);
}

// Download button functionality
function initializeDownloadButton() {
    const downloadButtons = document.querySelectorAll('a[href="#"]');
    
    downloadButtons.forEach(button => {
        if (button.textContent.includes('Download')) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Analytics tracking (if implemented)
                if (typeof gtag !== 'undefined') {
                    gtag('event', 'download_click', {
                        'event_category': 'engagement',
                        'event_label': 'macOS Download'
                    });
                }
                
                // Show download modal or redirect to actual download
                showDownloadModal();
            });
        }
    });
}

// Download modal (placeholder)
function showDownloadModal() {
    // This would show a modal with download options
    // For now, we'll just show an alert
    alert('Download will be available soon! The app is currently in development.');
}

// Utility functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Initialize download functionality
document.addEventListener('DOMContentLoaded', initializeDownloadButton);

// Add some interactive features for better UX
document.addEventListener('DOMContentLoaded', function() {
    // Add hover effects to feature cards
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
    
    // Add pulse effect to CTA buttons
    const ctaButtons = document.querySelectorAll('.btn-primary');
    ctaButtons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.animation = 'pulse 0.6s ease-in-out';
        });
        
        button.addEventListener('animationend', function() {
            this.style.animation = '';
        });
    });
});

// Add pulse animation CSS
const pulseStyles = `
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
    }
`;

const pulseStyleSheet = document.createElement('style');
pulseStyleSheet.textContent = pulseStyles;
document.head.appendChild(pulseStyleSheet);
