// ─── MPT NAVIGATION SYSTEM ─────────────────────────────────────
function mptToggle() {
  var sidebar = document.getElementById('mpt-sidebar');
  var overlay = document.getElementById('mpt-overlay');
  var hamburger = document.getElementById('mpt-hamburger');
  if (!sidebar) return;
  var isOpen = sidebar.classList.contains('open');
  if (isOpen) {
    sidebar.classList.remove('open');
    if (overlay) overlay.classList.remove('open');
    if (hamburger) hamburger.classList.remove('open');
    document.body.style.overflow = '';
  } else {
    sidebar.classList.add('open');
    if (overlay) overlay.classList.add('open');
    if (hamburger) hamburger.classList.add('open');
    document.body.style.overflow = 'hidden';
  }
}

var MPT_PAGE_MAP = {
  'index': 'index.html', 'about': 'about.html', 'aspects': 'aspects.html',
  'knowledge': 'knowledge.html', 'lifesciences': 'lifesciences.html',
  'vedicsciences': 'vedicsciences.html', 'metaphysics': 'metaphysics.html',
  'articles': 'articles.html', 'videos': 'videos.html', 'renewable': 'renewable.html',
  'impact': 'impact.html', 'partnership': 'partnership.html',
  'programs': 'programs.html', 'donate': 'donate.html', 'contact': 'contact.html'
};

function mptShow(pid) {
  var url = MPT_PAGE_MAP[pid];
  if (url) window.location.href = url;
}

document.addEventListener('DOMContentLoaded', function() {
  var path = window.location.pathname;
  var filename = path.split('/').pop().replace('.html', '') || 'index';
  document.querySelectorAll('.mpt-tab').forEach(function(tab) {
    if (tab.getAttribute('data-pid') === filename) {
      tab.classList.add('mpt-tab-active');
      tab.scrollIntoView({ inline: 'center', block: 'nearest' });
    }
  });
  document.querySelectorAll('.mpt-sb-link').forEach(function(link) {
    if (link.getAttribute('data-pid') === filename) link.classList.add('active');
  });
  var crumb = document.getElementById('mpt-crumb-name');
  if (crumb) {
    var label = document.querySelector('.mpt-tab.mpt-tab-active .mpt-tab-label');
    if (label) crumb.textContent = label.textContent;
  }
});

// ─── LEGACY HEADER / SCROLL ────────────────────────────────────
// Sticky Glassmorphic Header & Mobile Nav
document.addEventListener('DOMContentLoaded', () => {
  const nav = document.querySelector('nav');
  const navToggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  // Sticky scroll effect
  const topbar = document.getElementById('mpt-topbar');
  if (topbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 20) {
        topbar.classList.add('scrolled');
      } else {
        topbar.classList.remove('scrolled');
      }
    });
  }

  // Mobile toggle
  if (navToggle && navLinks) {
    navToggle.addEventListener('click', () => {
      const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', !isExpanded);
      navLinks.classList.toggle('nav-open');
    });
  }

  // Scroll Reveal
  const reveals = document.querySelectorAll('.reveal');
  const revealOnScroll = () => {
    const windowHeight = window.innerHeight;
    const elementVisible = 100;
    reveals.forEach(reveal => {
      const elementTop = reveal.getBoundingClientRect().top;
      if (elementTop < windowHeight - elementVisible) {
        reveal.classList.add('active');
      }
    });
  };
  window.addEventListener('scroll', revealOnScroll);
  revealOnScroll(); // Trigger on load

  // IntersectionObserver-based scroll reveal (.visible class)
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });

  document.querySelectorAll('.reveal, .reveal-stagger').forEach(el => {
    revealObserver.observe(el);
  });
});

// Category Tabs
document.querySelectorAll('.cat-pill, .tab-btn').forEach(pill => {
  pill.addEventListener('click', () => {
    document.querySelectorAll('.cat-pill, .tab-btn').forEach(p => p.classList.remove('active'));
    pill.classList.add('active');
  });
});

// Form Handlers
function handleVideoSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const btn = document.getElementById('video-submit-btn');
  if (!btn) return;
  
  const formData = new FormData(form);
  
  fetch('/', {
    method: 'POST',
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams(formData).toString()
  }).then(() => {
    btn.textContent = 'Video Submitted!';
    btn.style.background = 'var(--accent-gold)';
    btn.style.color = 'var(--bg-deep)';
    setTimeout(() => {
      btn.textContent = 'Submit Video';
      btn.style.background = '';
      btn.style.color = '';
      form.reset();
    }, 3000);
  }).catch(error => alert("Error submitting form: " + error));
}

function handleSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const btn = form.querySelector('button[type="submit"]');
  if (!btn) return;
  const originalText = btn.textContent;
  
  const formData = new FormData(form);

  fetch('/', {
    method: 'POST',
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams(formData).toString()
  }).then(() => {
    btn.textContent = 'Message Sent!';
    setTimeout(() => {
      btn.textContent = originalText;
      form.reset();
    }, 3000);
  }).catch(error => alert("Error submitting form: " + error));
}

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', function (e) {
    const targetId = this.getAttribute('href');
    if (targetId === '#' || targetId.includes('.html')) return;
    const targetElement = document.querySelector(targetId);
    if (targetElement) {
      e.preventDefault();
      targetElement.scrollIntoView({
        behavior: 'smooth'
      });
      const navLinks = document.querySelector('.nav-links');
      if (navLinks && navLinks.classList.contains('nav-open')) {
        navLinks.classList.remove('nav-open');
        document.querySelector('.nav-toggle').setAttribute('aria-expanded', 'false');
      }
    }
  });
});

// Animated counter for stats section
function animateCounter(el) {
  const target = parseInt(el.getAttribute('data-target'), 10);
  const duration = 1800;
  const startTime = performance.now();
  function tick(now) {
    const elapsed = Math.min(now - startTime, duration);
    const progress = elapsed / duration;
    const eased = 1 - Math.pow(1 - progress, 3);
    el.textContent = Math.floor(eased * target);
    if (elapsed < duration) requestAnimationFrame(tick);
    else el.textContent = target;
  }
  requestAnimationFrame(tick);
}

document.addEventListener('DOMContentLoaded', () => {
  const statsSection = document.getElementById('stats');
  if (statsSection) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.querySelectorAll('.counter').forEach(animateCounter);
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.3 });
    observer.observe(statsSection);
  }

  // Newsletter subscribe feedback
  document.querySelectorAll('.btn-subscribe').forEach(btn => {
    btn.addEventListener('click', function() {
      const input = this.closest('.newsletter-form')?.querySelector('.newsletter-email');
      if (!input || !input.value.includes('@')) return;
      const original = this.textContent;
      this.textContent = 'Subscribed!';
      this.style.background = '#3a5530';
      setTimeout(() => {
        this.textContent = original;
        this.style.background = '';
        if (input) input.value = '';
      }, 3000);
    });
  });
});

// Drive Folder Sync Configuration
const SUBMISSION_CONFIG = {
  articlesDriveUrl: "YOUR_GOOGLE_DRIVE_URL_HERE",
  videosDriveUrl: "YOUR_GOOGLE_DRIVE_URL_HERE"
};

document.addEventListener('DOMContentLoaded', () => {
  const articlesBtn = document.getElementById('archive-articles-btn');
  if (articlesBtn && SUBMISSION_CONFIG.articlesDriveUrl && !SUBMISSION_CONFIG.articlesDriveUrl.includes('YOUR_GOOGLE')) {
    articlesBtn.href = SUBMISSION_CONFIG.articlesDriveUrl;
    if (articlesBtn.parentElement) articlesBtn.parentElement.style.display = 'flex';
  }

  const videosBtn = document.getElementById('archive-videos-btn');
  if (videosBtn && SUBMISSION_CONFIG.videosDriveUrl && !SUBMISSION_CONFIG.videosDriveUrl.includes('YOUR_GOOGLE')) {
    videosBtn.href = SUBMISSION_CONFIG.videosDriveUrl;
    if (videosBtn.parentElement) videosBtn.parentElement.style.display = 'flex';
  }
});


// ─── PREMIUM MICRO-INTERACTIONS ────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // 1. Dynamic Cursor Glow on Cards
  const glowCards = document.querySelectorAll('.aspect-card, .conn-card, .kb-card, .impact-card, .partner-card, .donate-card, .stat-item');
  glowCards.forEach(card => {
    card.classList.add('premium-glow-card');
    card.addEventListener('mousemove', (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      card.style.setProperty('--mouse-x', `${x}px`);
      card.style.setProperty('--mouse-y', `${y}px`);
    });
  });

  // 2. Magnetic Glow on Primary Buttons
  const primaryBtns = document.querySelectorAll('.btn-primary');
  primaryBtns.forEach(btn => {
    // inject glow element
    const glow = document.createElement('div');
    glow.className = 'magnetic-glow';
    btn.appendChild(glow);
    
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      btn.style.setProperty('--x', `${x}px`);
      btn.style.setProperty('--y', `${y}px`);
    });
  });

  // 3. Staggered Reveal Logic
  const staggerContainers = document.querySelectorAll('.aspects-grid, .connections-grid, .kb-grid, .impact-grid, .partner-types, .donate-cards');
  staggerContainers.forEach(container => {
    // Add reveal-stagger class to children
    Array.from(container.children).forEach(child => {
      child.classList.add('reveal-stagger');
    });

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('active');
          const children = Array.from(entry.target.children);
          children.forEach((child, index) => {
            setTimeout(() => {
              child.classList.add('active');
            }, index * 100); // 100ms stagger
          });
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
    
    observer.observe(container);
  });
});


// Collapsible Sidebar Groups Accordion
function toggleSbGroup(btn) {
  const group = btn.parentElement;
  const content = group.querySelector('.mpt-sb-group-content');
  if (!group || !content) return;
  
  if (group.classList.contains('open')) {
    group.classList.remove('open');
    content.style.maxHeight = '0px';
  } else {
    group.classList.add('open');
    content.style.maxHeight = content.scrollHeight + 'px';
  }
}

// Initialise accordion heights on load
document.addEventListener('DOMContentLoaded', () => {
  const path = window.location.pathname;
  const filename = path.split('/').pop().replace('.html', '') || 'index';
  
  document.querySelectorAll('.mpt-sb-group').forEach(group => {
    const content = group.querySelector('.mpt-sb-group-content');
    if (!content) return;
    
    const hasActiveLink = Array.from(content.querySelectorAll('.mpt-sb-link')).some(link => {
      return link.getAttribute('data-pid') === filename;
    });
    
    if (hasActiveLink) {
      group.classList.add('open');
    }
    
    if (group.classList.contains('open')) {
      content.style.maxHeight = content.scrollHeight + 'px';
    } else {
      content.style.maxHeight = '0px';
    }
  });
});