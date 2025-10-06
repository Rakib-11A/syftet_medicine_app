# Pin npm packages by running ./bin/importmap

pin "application", to: "stimulus.js", preload: true
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/dist/stimulus.min.js"

# Automatically pin all controllers
pin_all_from "app/javascript/controllers", under: "controllers"
