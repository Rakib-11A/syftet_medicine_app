import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="test"
export default class extends Controller {
  static targets = ["name","output"]
  static values = {}
  
  connect() {
    console.log("Test controller connected!")
  }
  greet() {
      const name = this.nameTarget.value || "RAKIB"
      this.outputTarget.textContent = `As-salamu-alaikum, ${name}`
      alert(`As-salamu-alaikum, ${name}`)
  }
  // Add your methods here
}
