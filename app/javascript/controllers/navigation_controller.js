import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["searchInput", "searchForm", "mobileToggle", "mobileMenu", "sidebar", "sidebarOverlay"]
  static values = { 
    searchUrl: String,
    cartUpdateUrl: String,
    wishlistUpdateUrl: String 
  }

  connect() {
    console.log("Navigation controller connected!")
    console.log("Available targets:", this.constructor.targets)
    this.initializeBadges()
  }

  // Sidebar toggle
  toggleSidebar(event) {
    console.log("Toggle sidebar clicked!")
    event.preventDefault()
    
    if (this.hasSidebarTarget) {
      console.log("Sidebar target found:", this.sidebarTarget)
      const sidebar = this.sidebarTarget
      const overlay = this.sidebarOverlayTarget
      
      sidebar.classList.toggle('open')
      overlay.classList.toggle('show')
      document.body.classList.toggle('sidebar-open')
      
      console.log("Sidebar classes after toggle:", sidebar.classList.toString())
    } else {
      console.error("Sidebar target not found!")
    }
  }

  // Close sidebar
  closeSidebar(event) {
    console.log("Close sidebar clicked!")
    event.preventDefault()
    
    if (this.hasSidebarTarget) {
      const sidebar = this.sidebarTarget
      const overlay = this.sidebarOverlayTarget
      
      sidebar.classList.remove('open')
      overlay.classList.remove('show')
      document.body.classList.remove('sidebar-open')
    }
  }

  // Search functionality
  performSearch(event) {
    event.preventDefault()
    const searchTerm = this.searchInputTarget.value.trim()
    
    if (searchTerm.length > 0) {
      window.location.href = `/search?search=${encodeURIComponent(searchTerm)}`
    } else {
      alert('Please enter a search term')
    }
  }

  // Mobile menu toggle
  toggleMobileMenu() {
    this.mobileToggleTarget.classList.toggle('active')
  }

  // Close mobile menu when clicking outside
  closeMobileMenu(event) {
    if (!this.element.contains(event.target)) {
      this.mobileMenuTarget.classList.remove('show')
      this.mobileToggleTarget.classList.remove('active')
    }
  }

  // Upload prescription functionality
  uploadPrescription(event) {
    const fileInput = document.getElementById('prescription-file')
    const notes = document.getElementById('prescription-notes')
    
    if (!fileInput || fileInput.files.length === 0) {
      alert('Please select a prescription file')
      return
    }
    
    const file = fileInput.files[0]
    const maxSize = 5 * 1024 * 1024 // 5MB
    
    if (file.size > maxSize) {
      alert('File size must be less than 5MB')
      return
    }
    
    // Show loading state
    const button = event.target
    const originalText = button.innerHTML
    button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Uploading...'
    button.disabled = true
    
    // Simulate upload (replace with actual AJAX call)
    setTimeout(() => {
      alert('Prescription uploaded successfully! We will process it and contact you soon.')
      document.getElementById('uploadPrescriptionModal').classList.remove('show')
      button.innerHTML = originalText
      button.disabled = false
      document.getElementById('prescription-upload-form').reset()
    }, 2000)
  }

  // File input change handler
  handleFileChange(event) {
    const file = event.target.files[0]
    if (file) {
      const fileName = file.name
      const fileSize = (file.size / 1024 / 1024).toFixed(2)
      console.log(`Selected file: ${fileName} (${fileSize} MB)`)
    }
  }

  // Initialize badges
  initializeBadges() {
    this.updateCartBadge()
    this.updateWishlistBadge()
  }

  // Update cart badge
  updateCartBadge() {
    const cartBadge = document.querySelector('.badge-cart')
    if (cartBadge && cartBadge.textContent.trim() === '') {
      cartBadge.style.display = 'none'
    }
  }

  // Update wishlist badge
  updateWishlistBadge() {
    const wishlistBadge = document.querySelector('.badge-wishlist')
    if (wishlistBadge && wishlistBadge.textContent.trim() === '') {
      wishlistBadge.style.display = 'none'
    }
  }

  // Global functions for external updates
  updateCartCount(count) {
    const badge = document.querySelector('.badge-cart')
    if (count > 0) {
      badge.textContent = count
      badge.style.display = 'flex'
    } else {
      badge.style.display = 'none'
    }
  }

  updateWishlistCount(count) {
    const badge = document.querySelector('.badge-wishlist')
    if (count > 0) {
      badge.textContent = count
      badge.style.display = 'flex'
    } else {
      badge.style.display = 'none'
    }
  }

  // Smooth scroll for anchor links
  smoothScroll(event) {
    event.preventDefault()
    const target = document.querySelector(event.target.getAttribute('href'))
    if (target) {
      target.scrollIntoView({ 
        behavior: 'smooth',
        block: 'start'
      })
    }
  }

  // Add hover effects
  addHoverEffect(event) {
    event.target.classList.add('hover-effect')
  }

  removeHoverEffect(event) {
    event.target.classList.remove('hover-effect')
  }

  // Search input focus effects
  focusSearch(event) {
    event.target.closest('.input-group').classList.add('focused')
  }

  blurSearch(event) {
    event.target.closest('.input-group').classList.remove('focused')
  }
}
