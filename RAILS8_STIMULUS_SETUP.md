# Rails 8 Style Stimulus Setup ✅

## 🎉 Success! Stimulus is now set up the Rails 8 way!

Your app now uses **importmap** for modern JavaScript (Stimulus) while keeping **Sprockets** for existing assets.

## 📁 New Directory Structure

```
app/
├── assets/
│   └── javascripts/
│       └── application.js          # OLD: Sprockets (jQuery, existing code)
└── javascript/                     # NEW: Modern Rails 8 JavaScript
    ├── application.js              # Importmap entry point + controller registration
    └── controllers/                # Stimulus controllers (Rails 8 style)
        ├── application.js          # Stimulus application
        ├── index.js                # Controller registry
        └── hello_controller.js     # Demo controller
```

## 🔄 How It Works Now

### Two JavaScript Systems Working Together:

1. **Sprockets** (`app/assets/javascripts/`) - For existing code:
   - jQuery
   - Bootstrap plugins
   - Your existing custom JavaScript
   - Loaded via `<%= javascript_include_tag 'application' %>`

2. **Importmap** (`app/javascript/`) - For modern JavaScript:
   - Stimulus controllers
   - ES6 modules
   - Loaded via `<%= javascript_importmap_tags %>`

### Load Order in Layout:

```erb
<%= javascript_importmap_tags %>     <!-- 1. Stimulus (modern) -->
<%= javascript_include_tag 'application' %>  <!-- 2. jQuery & existing -->
```

---

## 🚀 Creating Controllers (Rails 8 Way)

### Step 1: Create Controller File

Create: `app/javascript/controllers/cart_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  static targets = ["count"]
  
  connect() {
    console.log("Cart controller connected!")
  }
  
  add(event) {
    event.preventDefault()
    // Your logic here
    console.log("Adding to cart...")
  }
}
```

### Step 2: Register Controller

Edit `app/javascript/application.js` and add your controller:

```javascript
// Import your new controller
import CartController from "controllers/cart_controller"
application.register("cart", CartController)
```

### Step 3: Use in Views

```erb
<div data-controller="cart">
  <button data-action="click->cart#add" class="btn">
    Add to Cart
  </button>
  
  <span data-cart-target="count">0</span>
</div>
```

### Step 4: Refresh Browser

**That's it!** Just refresh - no server restart needed!

---

## ✨ Key Differences from Before

| Aspect | OLD (Assets) | NEW (Rails 8) |
|--------|-------------|---------------|
| **Location** | `app/assets/javascripts/controllers/` | `app/javascript/controllers/` |
| **Style** | IIFE wrapper | ES6 modules |
| **Import** | Wait for global Stimulus | `import { Controller }` |
| **Export** | `Stimulus.register()` | `export default class` |
| **Registration** | Auto via Sprockets | Manual import in application.js |
| **Loading** | Sprockets | Importmap |

### Old Style (Assets):
```javascript
(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined') {
      clearInterval(waitForStimulus)
      class HelloController extends Controller { }
      Stimulus.register("hello", HelloController)
    }
  }, 50)
})()
```

### New Style (Rails 8):
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Your code
}
```

**Then register in `app/javascript/application.js`:**
```javascript
import HelloController from "controllers/hello_controller"
application.register("hello", HelloController)
```

**Much cleaner!** ✨

---

## 🧪 Test It Now

### 1. Browser Console Test

```bash
# Visit your app
http://localhost:3000

# Open console (F12) and type:
Stimulus
```

You should see: `Application {}`

### 2. Visual Demo

Add to any view:
```erb
<%= render 'shared/stimulus_demo' %>
```

Console should show:
```
Stimulus application loaded via importmap!
Hello controller connected (Rails 8 style)!
```

---

## 📝 Controller Template

Use this template for all new controllers:

```javascript
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="your-name"
export default class extends Controller {
  static targets = ["element"]
  static values = { 
    myValue: String,
    count: Number 
  }
  static classes = ["active"]
  
  connect() {
    console.log("Controller connected!")
  }
  
  disconnect() {
    // Cleanup when controller disconnects
  }
  
  myAction(event) {
    // Your code here
  }
}
```

**Don't forget to register it in `app/javascript/application.js`!**

---

## 🎯 Complete Example: Cart Controller

### 1. Create `app/javascript/controllers/cart_controller.js`:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count", "button"]
  
  connect() {
    console.log("Cart controller ready!")
  }
  
  async add(event) {
    event.preventDefault()
    const button = event.currentTarget
    const productId = button.dataset.productId
    
    // Show loading
    button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Adding...'
    
    try {
      const response = await fetch(`/cart/add/${productId}`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        }
      })
      
      const data = await response.json()
      
      // Update cart count
      if (this.hasCountTarget) {
        this.countTarget.textContent = data.cart_count
      }
      
      // Success state
      button.innerHTML = '<i class="fa fa-check"></i> Added!'
      setTimeout(() => {
        button.innerHTML = '<i class="fa fa-cart-plus"></i> Add to Cart'
      }, 2000)
      
    } catch (error) {
      console.error('Error:', error)
      button.innerHTML = '<i class="fa fa-exclamation"></i> Error'
    }
  }
}
```

### 2. Register in `app/javascript/application.js`:

```javascript
import CartController from "controllers/cart_controller"
application.register("cart", CartController)
```

### 3. Use in views:

```erb
<div data-controller="cart">
  <!-- Cart badge -->
  <span class="badge" data-cart-target="count">
    <%= @cart.items.count %>
  </span>
  
  <!-- Add to cart button -->
  <%= link_to "#", 
      class: "btn btn-primary",
      data: { 
        action: "click->cart#add",
        product_id: product.id 
      } do %>
    <i class="fa fa-cart-plus"></i> Add to Cart
  <% end %>
</div>
```

---

## 🔧 Configuration

### Enable Debug Mode

Edit `app/javascript/controllers/application.js`:

```javascript
application.debug = true  // Change to true
```

### Adding More Controllers

1. **Create** `app/javascript/controllers/your_controller.js`
2. **Register** in `app/javascript/application.js`:
   ```javascript
   import YourController from "controllers/your_controller"
   application.register("your", YourController)
   ```
3. **Use** in views with `data-controller="your"`
4. **Refresh** browser

---

## 🆚 Comparison

### What Changed:

✅ **Stimulus location**: `app/javascript/` (was: `app/assets/javascripts/`)  
✅ **ES6 modules**: Native imports (was: global script)  
✅ **Clean syntax**: No IIFE wrapper needed  
✅ **Manual registration**: Explicit imports (simple and clear)  

### What Stayed the Same:

✅ **Your existing JavaScript**: Still works in `app/assets/javascripts/`  
✅ **jQuery**: Still available  
✅ **Bootstrap**: Still working  
✅ **Views**: Same `data-controller` syntax  
✅ **No build tools**: Just refresh browser  

---

## 📚 Resources

- **Stimulus Handbook**: https://stimulus.hotwired.dev/handbook/introduction
- **Importmap Guide**: https://github.com/rails/importmap-rails
- **Rails 8 JavaScript**: https://guides.rubyonrails.org/working_with_javascript_in_rails.html

---

## ✅ Summary

You now have **the best of both worlds**:

1. ✨ **Modern Stimulus** in `app/javascript/` (Rails 8 way)
2. 🔧 **Existing assets** in `app/assets/javascripts/` (still working)
3. 🚀 **No build process** - just refresh!
4. 💪 **ES6 modules** - clean, modern code
5. 📦 **Simple registration** - explicit imports in application.js

**Your website works exactly as before, but now you can write Stimulus controllers the modern Rails 8 way!** 🎉

### Quick Reference:

```javascript
// 1. Create controller: app/javascript/controllers/name_controller.js
import { Controller } from "@hotwired/stimulus"
export default class extends Controller { }

// 2. Register: app/javascript/application.js
import NameController from "controllers/name_controller"
application.register("name", NameController)

// 3. Use: any view
<div data-controller="name">...</div>

// 4. Refresh browser ✅
``` 