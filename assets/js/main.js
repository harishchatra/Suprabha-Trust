// Sticky Glassmorphic Header & Mobile Nav
document.addEventListener('DOMContentLoaded', () => {
  const nav = document.querySelector('nav');
  const navToggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  // Sticky scroll effect
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  });

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
