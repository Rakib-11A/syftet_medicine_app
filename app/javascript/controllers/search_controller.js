import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results", "form"]
  static values = { 
    url: String,
    minLength: Number 
  }

  connect() {
    console.log("Search controller connected!")
    this.minLength = this.minLengthValue || 2
  }

  // Perform search on form submit
  search(event) {
    event.preventDefault()
    this.performSearch()
  }

  // Perform search on input change (with debounce)
  searchOnInput() {
    clearTimeout(this.searchTimeout)
    this.searchTimeout = setTimeout(() => {
      if (this.inputTarget.value.length >= this.minLength) {
        this.performSearch()
      }
    }, 300)
  }

  // Clear search results
  clearSearch() {
    this.inputTarget.value = ''
    this.resultsTarget.innerHTML = ''
    this.resultsTarget.style.display = 'none'
  }

  // Perform the actual search
  async performSearch() {
    const query = this.inputTarget.value.trim()
    
    if (query.length < this.minLength) {
      return
    }

    try {
      // Show loading state
      this.showLoading()
      
      // Make search request
      const response = await fetch(`/search?search=${encodeURIComponent(query)}`)
      const html = await response.text()
      
      // Parse and display results
      this.displayResults(html)
      
    } catch (error) {
      console.error('Search error:', error)
      this.showError('Search failed. Please try again.')
    }
  }

  // Show loading state
  showLoading() {
    this.resultsTarget.innerHTML = `
      <div class="search-loading">
        <i class="fa fa-spinner fa-spin"></i> Searching...
      </div>
    `
    this.resultsTarget.style.display = 'block'
  }

  // Display search results
  displayResults(html) {
    // Extract just the search results from the full page
    const parser = new DOMParser()
    const doc = parser.parseFromString(html, 'text/html')
    const searchResults = doc.querySelector('.container')
    
    if (searchResults) {
      this.resultsTarget.innerHTML = searchResults.innerHTML
      this.resultsTarget.style.display = 'block'
    } else {
      this.showError('No results found')
    }
  }

  // Show error message
  showError(message) {
    this.resultsTarget.innerHTML = `
      <div class="search-error">
        <i class="fa fa-exclamation-triangle"></i> ${message}
      </div>
    `
    this.resultsTarget.style.display = 'block'
  }

  // Hide results when clicking outside
  hideResults(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.style.display = 'none'
    }
  }

  // Handle keyboard navigation
  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.resultsTarget.style.display = 'none'
    }
  }
}
