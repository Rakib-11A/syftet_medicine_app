# ✅ Stimulus Auto-Registration (Rails 8 Style)

## 🎉 Perfect! You Now Have Automatic Controller Registration!

Just like standard Rails 8, controllers are **automatically discovered and registered**!

---

## 🚀 How It Works

### The Magic:

When your app loads, `app/javascript/stimulus.js` automatically:
1. 🔍 Scans `app/javascript/controllers/` for any `*_controller.js` files
2. 📦 Imports them automatically
3. 🎯 Registers them with the correct name
4. ✨ **No manual imports needed!**

### The Code:

```javascript
// Auto-register all controllers
const context = import.meta.glob("./controllers/**/*_controller.js", { eager: true })

for (const path in context) {
  const module = context[path]
  const name = path
    .replace("./controllers/", "")
    .replace("_controller.js", "")
    .replace(/_/g, "-")
  
  if (module.default) {
    application.register(name, module.default)
  }
}
```

---

## 🎯 Super Simple Workflow

### 1. Generate Controller

```bash
rails g stimulus cart
```

**That's it!** The controller is automatically:
- ✅ Created
- ✅ Registered (no manual import needed!)
- ✅ Ready to use

### 2. Use in Views

```erb
<div data-controller="cart">
  <button data-action="click->cart#add">Add to Cart</button>
</div>
```

### 3. Refresh Browser

**Done!** ✨ No manual registration, no importmap edits!

---

## 📝 Examples

### Example 1: Product Filter

```bash
# Generate
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

**Use:**

```erb
<div data-controller="product-filter">
  <input data-product-filter-target="input"
         data-action="input->product-filter#filter">
  
  <% @products.each do |product| %>
    <div data-product-filter-target="product" 
         data-product-name="<%= product.name %>">
      <%= product.name %>
    </div>
  <% end %>
</div>
```

**Refresh** → Works automatically! ✅

---

### Example 2: Dropdown

```bash
# Generate
rails g stimulus dropdown
```

**Edit** `app/javascript/controllers/dropdown_controller.js`:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  toggle() {
    this.menuTarget.classList.toggle("show")
  }
}
```

**Use:**

```erb
<div data-controller="dropdown">
  <button data-action="click->dropdown#toggle">Menu</button>
  <div data-dropdown-target="menu" class="dropdown-menu">
    <a href="#">Item 1</a>
  </div>
</div>
```

**Refresh** → Works automatically! ✅

---

## 🗑️ Deleting Controllers

```bash
# Just destroy it
rails d stimulus product_filter

# Refresh browser
# That's it - automatically unregistered!
```

---

## 📂 Directory Structure

```
app/javascript/
├── stimulus.js                    # Auto-loader (don't edit this!)
└── controllers/
    ├── hello_controller.js        # Auto-registered as "hello"
    ├── test_controller.js         # Auto-registered as "test"
    ├── cart_controller.js         # Auto-registered as "cart"
    └── product_filter_controller.js  # Auto-registered as "product-filter"
```

**Notice:** No manual imports! Just drop files in `controllers/` folder!

---

## 🎯 Naming Convention

| File Name | Registered As | Use in HTML |
|-----------|---------------|-------------|
| `cart_controller.js` | `cart` | `data-controller="cart"` |
| `product_filter_controller.js` | `product-filter` | `data-controller="product-filter"` |
| `image_gallery_controller.js` | `image-gallery` | `data-controller="image-gallery"` |

**Rule:** Underscores (`_`) become dashes (`-`) in HTML!

---

## ✨ Key Features

### ✅ Automatic Discovery
Drop a `*_controller.js` file in `app/javascript/controllers/` and it's automatically found!

### ✅ No Manual Imports
You never edit `stimulus.js` - it auto-loads everything!

### ✅ No Importmap Edits
`pin_all_from` handles all controllers automatically!

### ✅ Just Refresh
No server restart, no configuration - just refresh browser!

---

## 🔧 Configuration Files

### `config/importmap.rb`
```ruby
pin "application", to: "stimulus.js", preload: true
pin "@hotwired/stimulus", to: "https://cdn.jsdelivr.net/..."
pin_all_from "app/javascript/controllers", under: "controllers"
```

**`pin_all_from`** = automatic discovery! 🎯

### `app/javascript/stimulus.js`
```javascript
// Auto-register all controllers
const context = import.meta.glob("./controllers/**/*_controller.js", { eager: true })

for (const path in context) {
  // Automatically registers each controller
}
```

**`import.meta.glob`** = automatic loading! 🎯

---

## 🧪 Testing Auto-Registration

### Console Test (F12):

```javascript
// See all registered controllers
Stimulus.router.modulesByIdentifier

// Should show:
// { hello: Module, test: Module, cart: Module }
```

All controllers automatically appear!

---

## 📚 Complete Workflow

```bash
# 1. Generate controller
rails g stimulus my_feature

# 2. Edit the file
# app/javascript/controllers/my_feature_controller.js

# 3. Use in view
# <div data-controller="my-feature">...</div>

# 4. Refresh browser

# ✅ DONE! No manual registration needed!
```

---

## 🆚 Comparison

### Before (Manual):
```javascript
// Had to edit stimulus.js every time:
import CartController from "controllers/cart_controller"
application.register("cart", CartController)

import FilterController from "controllers/filter_controller"  
application.register("filter", FilterController)
// etc...
```

### Now (Automatic):
```javascript
// Just drop files in controllers/ folder
// They auto-register! ✨
```

---

## ✅ Summary

**This is exactly how Rails 8 Stimulus works!**

1. ✅ **Create file** in `app/javascript/controllers/`
2. ✅ **Auto-registered** (no manual imports)
3. ✅ **Auto-pinned** (no importmap edits)
4. ✅ **Just refresh** browser

**Create controllers freely - they just work!** 🚀

---

## 💡 Quick Reference

```bash
# Generate controller
rails g stimulus name

# File created: app/javascript/controllers/name_controller.js
# Auto-registered as: "name"
# Use as: data-controller="name"

# Refresh browser ✅
```

**That's it! Pure Rails 8 magic!** ✨ 