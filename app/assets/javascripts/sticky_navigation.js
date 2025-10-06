// Sticky Navigation Enhancement
$(document).ready(function() {
  let lastScrollTop = 0;
  let ticking = false;
  
  function setNavbarSpacerHeight() {
    const $navbar = $('.navbar-default');
    const $spacer = $('#navbar-spacer');
    if ($navbar.length && $spacer.length) {
      $spacer.height($navbar.outerHeight());
    }
  }

  function updateNavbarOffset() {
    const $navbar = $('.navbar-default');
    const $topNav = $('.top_nav');
    if (!$navbar.length) return;

    const scrollTop = $(window).scrollTop();
    const topNavHeight = $topNav.length ? $topNav.outerHeight() : 0;

    // While the top bar is visible (not fully scrolled past), keep the navbar below it
    const desiredTop = Math.max(0, topNavHeight - scrollTop);
    $navbar.css('top', desiredTop + 'px');
  }
  
  function updateNavbar() {
    const scrollTop = $(window).scrollTop();
    const navbar = $('.navbar-default');
    
    // Add scrolled class for enhanced styling
    if (scrollTop > 50) {
      navbar.addClass('navbar-scrolled');
    } else {
      navbar.removeClass('navbar-scrolled');
    }

    // Keep navbar visible; do not slide it above on scroll
    navbar.css('transform', 'translateY(0)');
    
    // Update top offset against top bar
    updateNavbarOffset();

    lastScrollTop = scrollTop;
    ticking = false;
  }
  
  function requestTick() {
    if (!ticking) {
      requestAnimationFrame(updateNavbar);
      ticking = true;
    }
  }
  
  // Listen for scroll events with throttling
  $(window).on('scroll', requestTick);
  $(window).on('resize', setNavbarSpacerHeight);
  $(window).on('resize', updateNavbarOffset);
  
  // Initial call to set up navbar state
  setNavbarSpacerHeight();
  updateNavbarOffset();
  updateNavbar();
  
  console.log('✅ Sticky navigation enhanced');
});

// Fallback for when jQuery is not available
document.addEventListener('DOMContentLoaded', function() {
  let lastScrollTop = 0;
  let ticking = false;
  
  function setNavbarSpacerHeight() {
    const navbar = document.querySelector('.navbar-default');
    const spacer = document.getElementById('navbar-spacer');
    if (navbar && spacer) {
      spacer.style.height = navbar.offsetHeight + 'px';
    }
  }

  function updateNavbarOffset() {
    const navbar = document.querySelector('.navbar-default');
    const topNav = document.querySelector('.top_nav');
    if (!navbar) return;

    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    const topNavHeight = topNav ? topNav.offsetHeight : 0;

    const desiredTop = Math.max(0, topNavHeight - scrollTop);
    navbar.style.top = desiredTop + 'px';
  }
  
  function updateNavbar() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    const navbar = document.querySelector('.navbar-default');
    
    if (navbar) {
      // Add scrolled class for enhanced styling
      if (scrollTop > 50) {
        navbar.classList.add('navbar-scrolled');
      } else {
        navbar.classList.remove('navbar-scrolled');
      }

      // Keep navbar visible; do not slide it above on scroll
      navbar.style.transform = 'translateY(0)';
    }
    
    // Update top offset against top bar
    updateNavbarOffset();

    lastScrollTop = scrollTop;
    ticking = false;
  }
  
  function requestTick() {
    if (!ticking) {
      requestAnimationFrame(updateNavbar);
      ticking = true;
    }
  }
  
  // Listen for scroll events with throttling
  window.addEventListener('scroll', requestTick);
  window.addEventListener('resize', setNavbarSpacerHeight);
  window.addEventListener('resize', updateNavbarOffset);
  
  // Initial call to set up navbar state
  setNavbarSpacerHeight();
  updateNavbarOffset();
  updateNavbar();
  
  console.log('✅ Sticky navigation enhanced (fallback)');
});
