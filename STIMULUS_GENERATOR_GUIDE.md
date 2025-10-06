# ✅ Stimulus Generator Guide

## 🎉 You Can Now Use Rails Commands!

You have **custom Rails generators** for Stimulus controllers!

---

## 📝 Generate a Controller

### Command:
```bash
rails generate stimulus name
# or short version:
rails g stimulus name
```

### Examples:

```bash
# Create a cart controller
rails g stimulus cart

# Create a product filter controller
rails g stimulus product_filter

# Create an image gallery controller
rails g stimulus image_gallery
```

### What It Does:

1. ✅ Creates `app/javascript/controllers/name_controller.js`
2. ✅ Registers it in `app/javascript/stimulus.js`
3. ✅ Adds pin to `config/importmap.rb`
4. ✅ Shows usage example

### Output Example:

```
create  app/javascript/controllers/cart_controller.js
✅ Registered in stimulus.js
✅ Added to importmap.rb

✅ Stimulus controller created!

📝 Usage in views:
  <div data-controller="cart">
    <!-- your content -->
  </div>

🔄 Refresh your browser to see it work!
```

---

## 🗑️ Destroy a Controller

### Command:
```bash
rails destroy stimulus name
# or short version:
rails d stimulus name
```

### Examples:

```bash
# Remove the cart controller
rails d stimulus cart

# Remove product_filter controller
rails d stimulus product_filter
```

### What It Does:

1. ✅ Removes `app/javascript/controllers/name_controller.js`
2. ✅ Unregisters from `app/javascript/stimulus.js`
3. ✅ Removes pin from `config/importmap.rb`

---

## 📂 Generated File Structure

When you run `rails g stimulus cart`:

```javascript
// app/javascript/controllers/cart_controller.js

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  static targets = []
  static values = {}
  
  connect() {
    console.log("Cart controller connected!")
  }
  
  // Add your methods here
}
```

**Then it's automatically registered in:**
- `app/javascript/stimulus.js`
- `config/importmap.rb`

---

## 🎯 Usage Examples

### Example 1: Cart Controller

**Generate:**
```bash
rails g stimulus cart
```

**Edit** `app/javascript/controllers/cart_controller.js`:
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count"]
  
  connect() {
    console.log("Cart controller connected!")
  }
  
  add(event) {
    event.preventDefault()
    alert("Adding to cart!")
  }
}
```

**Use in view:**
```erb
<div data-controller="cart">
  <button data-action="click->cart#add" class="btn btn-primary">
    <i class="fa fa-cart-plus"></i> Add to Cart
  </button>
  <span data-cart-target="count">0</span>
</div>
```

**Refresh browser** ✅

---

### Example 2: Product Filter

**Generate:**
```bash
rails g stimulus product_filter
```

**Edit** `app/javascript/controllers/product_filter_controller.js`:
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "product"]
  
  filter() {
    const query = this.inputTarget.value.toLowerCase()
    
    this.productTargets.forEach(product => {
      const name = product.dataset.productName.toLowerCase()
      product.style.display = name.includes(query) ? 'block' : 'none'
    })
  }
}
```

**Use in view:**
```erb
<div data-controller="product-filter">
  <input 
    data-product-filter-target="input"
    data-action="input->product-filter#filter"
    placeholder="Search products..."
    class="form-control"
  >
  
  <% @products.each do |product| %>
    <div data-product-filter-target="product" 
         data-product-name="<%= product.name %>">
      <%= product.name %>
    </div>
  <% end %>
</div>
```

---

## 🎨 Controller Template

Every generated controller starts with this template:

```javascript
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="name"
export default class extends Controller {
  static targets = []        // Elements you want to reference
  static values = {}         // Values passed from HTML
  
  connect() {
    console.log("Controller connected!")
  }
  
  // Add your methods here
}
```

### Common Patterns:

**Add targets:**
```javascript
static targets = ["output", "input", "button"]

// Access them:
this.outputTarget
this.inputTarget
this.buttonTarget
```

**Add values:**
```javascript
static values = { 
  url: String, 
  count: Number,
  open: Boolean 
}

// Access them:
this.urlValue
this.countValue
this.openValue
```

**Add classes:**
```javascript
static classes = ["active", "hidden"]

// Use them:
element.classList.add(this.activeClass)
element.classList.toggle(this.hiddenClass)
```

---

## 🔄 Workflow

### Creating a New Feature:

```bash
# 1. Generate controller
rails g stimulus my_feature

# 2. Edit the controller file
# app/javascript/controllers/my_feature_controller.js

# 3. Add HTML to your view
# <div data-controller="my-feature">...</div>

# 4. Refresh browser
# Done!
```

### Removing a Feature:

```bash
# Just destroy it
rails d stimulus my_feature

# Refresh browser
# Done!
```

---

## 📚 Quick Reference

| Command | Purpose |
|---------|---------|
| `rails g stimulus name` | Create new Stimulus controller |
| `rails d stimulus name` | Delete Stimulus controller |
| `bin/stimulus name` | Alternative generator (older style) |

### File Locations:

```
app/javascript/
├── stimulus.js                        # Entry point & registrations
└── controllers/
    ├── application.js                 # Stimulus config
    ├── index.js                       # Controller index
    ├── hello_controller.js            # Demo
    └── your_controller.js             # Your controllers
```

---

## ✅ Summary

You can now:

1. ✅ **Generate** controllers: `rails g stimulus name`
2. ✅ **Destroy** controllers: `rails d stimulus name`
3. ✅ **Auto-registration** in stimulus.js and importmap.rb
4. ✅ **Clean workflow** - just like other Rails generators!

**Your Stimulus setup is complete and production-ready!** 🚀 