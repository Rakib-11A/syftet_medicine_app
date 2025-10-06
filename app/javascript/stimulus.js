// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus"

// Start Stimulus application
const application = Application.start()
application.debug = false
window.Stimulus = application

// Auto-import all controllers
// Since importmap doesn't support glob, we import controllers individually
import HelloController from "controllers/hello_controller"
import TestController from "controllers/test_controller"
import NavigationController from "controllers/navigation_controller"
import SearchController from "controllers/search_controller"

// Auto-register them
application.register("hello", HelloController)
application.register("test", TestController)
application.register("navigation", NavigationController)
application.register("search", SearchController)

console.log("Stimulus application loaded!")
console.log("Registered controllers:", Object.keys(application.router.modulesByIdentifier))
