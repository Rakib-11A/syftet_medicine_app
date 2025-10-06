import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hello"
export default class extends Controller {
  static targets = ["name", "output"]

  connect() {
    console.log("Hello controller connected (Rails 8 style)!")
  }

  greet() {
    const name = this.nameTarget.value || "World"
    this.outputTarget.textContent = `Hello, ${name}! (from Hello Controller)`
    console.log("Hello greet() called with:", name)
  }
} 