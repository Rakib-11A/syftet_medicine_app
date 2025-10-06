# Stimulus Guide for Your Rails App

## ✅ Stimulus is Installed!

Stimulus has been successfully installed in your Rails 8 application using importmap.

## 📁 File Structure

```
app/javascript/
├── application.js           # Stimulus initialization
└── controllers/
    ├── index.js            # Controller registry
    └── hello_controller.js # Example controller
```

## 🎯 How to Use Stimulus

### 1. Test the Demo

Add this to any view to test Stimulus:

```erb
<%= render 'shared/stimulus_demo' %>
```

For example, add it to `app/views/home/index.html.erb` temporarily.

### 2. Create a New Controller

**Generate a controller:**

```bash
# Create file: app/javascript/controllers/dropdown_controller.js
```

**Example controller:**

```javascript
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = [ "menu" ]
  static values = { open: Boolean }

  connect() {
    console.log("Dropdown controller connected!")
  }

  toggle() {
    this.menuTarget.classList.toggle("show")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("show")
    }
  }
}
```

**Register it in `app/javascript/controllers/index.js`:**

```javascript
import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)
```

### 3. Use in HTML/ERB

```erb
<div data-controller="dropdown">
  <button data-action="click->dropdown#toggle">
    Toggle Menu
  </button>
  
  <div data-dropdown-target="menu" class="dropdown-menu">
    <a href="#">Item 1</a>
    <a href="#">Item 2</a>
  </div>
</div>
```

## 📚 Stimulus Concepts

### Data Attributes

- `data-controller="name"` - Connects element to controller
- `data-action="event->controller#method"` - Event listener
- `data-controller-target="name"` - Target element
- `data-controller-value="..."` - Value passed to controller

### Common Patterns

**Click event:**
```html
<button data-action="click->hello#greet">Click me</button>
```

**Form submit:**
```html
<form data-controller="search" data-action="submit->search#filter">
```

**Multiple controllers:**
```html
<div data-controller="dropdown modal">
```

**Multiple actions:**
```html
<input data-action="focus->form#highlight blur->form#reset">
```

## 🔥 Real-World Examples for Your App

### Example 1: Product Quick View

```javascript
// app/javascript/controllers/product_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  showQuickview(event) {
    event.preventDefault()
    const productId = event.currentTarget.dataset.productId
    
    fetch(`/products/${productId}/quickview`)
      .then(response => response.text())
      .then(html => {
        this.modalTarget.innerHTML = html
        $(this.modalTarget).modal('show') // Bootstrap modal
      })
  }
}
```

```erb
<div data-controller="product">
  <%= link_to "Quick View", "#", 
      data: { 
        action: "click->product#showQuickview",
        product_id: product.id 
      } %>
  
  <div data-product-target="modal" class="modal"></div>
</div>
```

### Example 2: Cart Counter

```javascript
// app/javascript/controllers/cart_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "count", "total" ]
  static values = { items: Number }

  addItem() {
    this.itemsValue++
    this.updateDisplay()
  }

  removeItem() {
    if (this.itemsValue > 0) {
      this.itemsValue--
      this.updateDisplay()
    }
  }

  updateDisplay() {
    this.countTarget.textContent = this.itemsValue
  }
}
```

### Example 3: Form Validation

```javascript
// app/javascript/controllers/form_validation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "email", "error" ]

  validateEmail() {
    const email = this.emailTarget.value
    const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
    
    if (!isValid) {
      this.errorTarget.textContent = "Please enter a valid email"
      this.emailTarget.classList.add("is-invalid")
    } else {
      this.errorTarget.textContent = ""
      this.emailTarget.classList.remove("is-invalid")
    }
  }
}
```

## 🚀 Next Steps

1. **Test the demo** - Add `<%= render 'shared/stimulus_demo' %>` to a view
2. **Convert existing jQuery** - Gradually replace jQuery code with Stimulus
3. **Read the docs** - https://stimulus.hotwired.dev/

## 🔧 Debugging

**Enable debug mode** in `app/javascript/application.js`:

```javascript
application.debug = true
```

**Check console** - You should see "Hello controller connected!" when the demo loads.

## 📦 Adding More Controllers

1. Create file: `app/javascript/controllers/yourname_controller.js`
2. Register in: `app/javascript/controllers/index.js`
3. Use in views: `data-controller="yourname"`

That's it! Stimulus is ready to use. 🎉 