# Stimulus Guide (CDN + Sprockets Setup)

## ✅ Setup Complete!

Stimulus is now working in your Rails app using **CDN + Sprockets Asset Pipeline**.

## 📁 File Structure

```
app/assets/javascripts/
├── application.js                      # Manifest (loads everything)
├── stimulus_setup.js                   # Stimulus initialization check
└── controllers/
    └── hello_controller.js            # Demo controller
```

## 🎯 How to Use

### 1. Test the Demo

Add this to any view (e.g., `app/views/home/index.html.erb`):

```erb
<%= render 'shared/stimulus_demo' %>
```

Reload the page and check your browser console. You should see:
- "Stimulus loaded and ready!"
- "Hello controller registered!"
- "Hello controller connected!" (when demo loads)

### 2. Create a New Controller

**Step 1:** Create file `app/assets/javascripts/controllers/YOUR_NAME_controller.js`:

```javascript
(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined' && typeof Controller !== 'undefined') {
      clearInterval(waitForStimulus)
      
      class DropdownController extends Controller {
        static targets = ["menu"]
        
        connect() {
          console.log("Dropdown connected!")
        }
        
        toggle() {
          this.menuTarget.classList.toggle("show")
        }
      }
      
      Stimulus.register("dropdown", DropdownController)
    }
  }, 50)
})()
```

**Step 2:** Use in your ERB views:

```erb
<div data-controller="dropdown">
  <button data-action="click->dropdown#toggle" class="btn btn-primary">
    Toggle Menu
  </button>
  
  <div data-dropdown-target="menu" class="dropdown-menu">
    <a href="#">Item 1</a>
    <a href="#">Item 2</a>
  </div>
</div>
```

**Step 3:** Refresh your page (Sprockets will automatically include it)

## 🔥 Real Examples

### Product Quick View

```javascript
// app/assets/javascripts/controllers/product_controller.js
(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined' && typeof Controller !== 'undefined') {
      clearInterval(waitForStimulus)
      
      class ProductController extends Controller {
        showQuickview(event) {
          event.preventDefault()
          const productId = event.currentTarget.dataset.productId
          
          $.ajax({
            url: `/products/${productId}/quickview`,
            type: 'GET',
            success: function(html) {
              $('#quickview-modal .modal-body').html(html)
              $('#quickview-modal').modal('show')
            }
          })
        }
      }
      
      Stimulus.register("product", ProductController)
    }
  }, 50)
})()
```

```erb
<div data-controller="product">
  <%= link_to "Quick View", "#", 
      data: { 
        action: "click->product#showQuickview",
        product_id: product.id 
      }, 
      class: "btn btn-sm" %>
</div>
```

### Cart Counter

```javascript
// app/assets/javascripts/controllers/cart_counter_controller.js
(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined' && typeof Controller !== 'undefined') {
      clearInterval(waitForStimulus)
      
      class CartCounterController extends Controller {
        static targets = ["count"]
        static values = { items: Number }
        
        connect() {
          this.updateDisplay()
        }
        
        increment() {
          this.itemsValue++
          this.updateDisplay()
        }
        
        decrement() {
          if (this.itemsValue > 0) {
            this.itemsValue--
            this.updateDisplay()
          }
        }
        
        updateDisplay() {
          this.countTarget.textContent = this.itemsValue
        }
      }
      
      Stimulus.register("cart-counter", CartCounterController)
    }
  }, 50)
})()
```

## 📝 Controller Template

Use this template for all new controllers:

```javascript
(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined' && typeof Controller !== 'undefined') {
      clearInterval(waitForStimulus)
      
      class YourNameController extends Controller {
        static targets = ["element"]
        static values = { something: String }
        
        connect() {
          console.log("YourName controller connected!")
        }
        
        yourMethod() {
          // Your code here
        }
      }
      
      Stimulus.register("your-name", YourNameController)
    }
  }, 50)
})()
```

## 🚀 Key Points

1. **Controllers auto-load** - Just create in `app/assets/javascripts/controllers/`
2. **No restart needed** - Refresh page to see changes (in development)
3. **Works with jQuery** - You can use `$()` inside controllers
4. **Debug mode** - Set `window.Stimulus.debug = true` in layout

## 🔧 Troubleshooting

**Controller not working?**
1. Check browser console for errors
2. Verify file is in `app/assets/javascripts/controllers/`
3. Make sure you wrapped code in `waitForStimulus` function
4. Clear browser cache and refresh

**Stimulus not defined?**
1. Check that the CDN script is in your layout
2. Look for "Stimulus loaded and ready!" in console
3. Try hard refresh (Ctrl+Shift+R)

## 📚 Learn More

- Official Docs: https://stimulus.hotwired.dev/
- Handbook: https://stimulus.hotwired.dev/handbook/introduction

That's it! Start building! 🎉 