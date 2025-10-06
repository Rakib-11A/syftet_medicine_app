# Stimulus Usage Examples - Your E-commerce App

## ✅ Installed Controllers

You now have **4 Stimulus controllers** ready to use:

1. **hello** - Demo controller (testing)
2. **cart** - Add to cart with animations
3. **image-gallery** - Product image gallery
4. **dropdown** - Dropdown menus

## 📁 File Locations

```
app/assets/javascripts/controllers/
├── hello_controller.js           # Demo
├── cart_controller.js            # Shopping cart
├── image_gallery_controller.js   # Product images
└── dropdown_controller.js        # Dropdowns
```

---

## 🛒 1. Cart Controller

### Purpose
Add products to cart with loading animations and feedback.

### Usage in Product Views

**In `app/views/products/_product.html.erb`:**

```erb
<div class="product" data-controller="cart">
  <h4><%= product.name %></h4>
  <p><%= number_to_currency(product.price) %></p>
  
  <!-- Cart count badge (optional) -->
  <span class="badge" data-cart-target="count">
    <%= current_cart.items.count %>
  </span>
  
  <!-- Add to Cart Button -->
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

### Features:
- ✅ Shows loading spinner while adding
- ✅ Updates cart count automatically
- ✅ Success animation with checkmark
- ✅ Works with your existing `popupMessage()` function
- ✅ Uses AJAX (no page reload)

### Backend Required:
You'll need a route that returns JSON:
```ruby
# routes.rb
post 'cart/add/:id', to: 'carts#add'

# carts_controller.rb
def add
  product = Product.find(params[:id])
  @cart.add(product)
  
  render json: { 
    cart_count: @cart.items.count,
    message: 'Product added successfully'
  }
end
```

---

## 🖼️ 2. Image Gallery Controller

### Purpose
Switch between product images with smooth transitions.

### Usage in Product Show Page

**In `app/views/products/show.html.erb`:**

```erb
<div data-controller="image-gallery" class="product-images">
  <!-- Main Image -->
  <div class="main-image">
    <img 
      src="<%= @product.images.first.url %>" 
      alt="<%= @product.name %>"
      data-image-gallery-target="mainImage"
      class="img-responsive"
      style="transition: opacity 0.3s;"
    >
  </div>
  
  <!-- Thumbnails -->
  <div class="thumbnails">
    <% @product.images.each do |image| %>
      <a href="#" 
         data-action="click->image-gallery#changeImage"
         data-image-gallery-target="thumbnail"
         data-image-url="<%= image.url %>"
         class="thumbnail">
        <img src="<%= image.thumb.url %>" alt="Thumbnail">
      </a>
    <% end %>
  </div>
</div>
```

### Add CSS for active state:

```css
.thumbnail.active {
  border: 2px solid #007bff;
  opacity: 1;
}

.thumbnail {
  opacity: 0.6;
  cursor: pointer;
}
```

### Features:
- ✅ Smooth fade transitions
- ✅ Active thumbnail highlighting
- ✅ Click to switch images
- ✅ No page reload

---

## 📋 3. Dropdown Controller

### Purpose
Create accessible dropdowns that close when clicking outside.

### Usage in Navigation

**In `app/views/shared/_main_menu.html.erb`:**

```erb
<div data-controller="dropdown" class="dropdown">
  <!-- Trigger Button -->
  <button 
    data-action="click->dropdown#toggle"
    class="btn btn-default dropdown-toggle"
  >
    Categories <i class="fa fa-caret-down"></i>
  </button>
  
  <!-- Dropdown Menu -->
  <div data-dropdown-target="menu" class="dropdown-menu">
    <% Category.all.each do |category| %>
      <%= link_to category.name, category_path(category), class: 'dropdown-item' %>
    <% end %>
  </div>
</div>
```

### Add CSS:

```css
.dropdown-menu {
  display: none;
  position: absolute;
  background: white;
  border: 1px solid #ddd;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  z-index: 1000;
}

.dropdown-menu.show {
  display: block;
}
```

### Features:
- ✅ Click outside to close
- ✅ Toggle on/off
- ✅ Clean event handling
- ✅ Works with multiple dropdowns on same page

---

## 🎉 4. Hello Controller (Demo)

### Purpose
Test that Stimulus is working.

### Usage

**Add to any view:**

```erb
<%= render 'shared/stimulus_demo' %>
```

Or test in browser console:
```javascript
Stimulus  // Should show the application object
```

---

## 🚀 Quick Start Guide

### 1. Test Stimulus is Working

```bash
# Visit your app
http://localhost:3000

# Open console (F12) and type:
Stimulus
```

### 2. Add Demo to Homepage

Edit `app/views/home/index.html.erb`:

```erb
<!-- Add this anywhere in the file -->
<%= render 'shared/stimulus_demo' %>
```

### 3. Use a Controller in Your View

Pick any controller above and copy the HTML examples into your views!

---

## 📝 Controller Template

Want to create your own? Use this template:

```javascript
// app/assets/javascripts/controllers/myfeature_controller.js

(function() {
  const waitForStimulus = setInterval(function() {
    if (typeof Stimulus !== 'undefined' && typeof Controller !== 'undefined') {
      clearInterval(waitForStimulus)
      
      class MyfeatureController extends Controller {
        static targets = ["element"]
        static values = { someProp: String }
        
        connect() {
          console.log("Myfeature connected!")
        }
        
        myAction() {
          // Your code here
          console.log("Action triggered!")
        }
      }
      
      Stimulus.register("myfeature", MyfeatureController)
    }
  }, 50)
})()
```

Then use it:

```erb
<div data-controller="myfeature">
  <button data-action="click->myfeature#myAction">
    Click Me
  </button>
</div>
```

---

## 🎯 Stimulus Cheat Sheet

### Data Attributes

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `data-controller="name"` | Connect element to controller | `data-controller="cart"` |
| `data-action="event->controller#method"` | Event listener | `data-action="click->cart#add"` |
| `data-controllername-target="name"` | Reference element | `data-cart-target="count"` |
| `data-controllername-value="..."` | Pass value | `data-product-id="123"` |

### Common Patterns

**Click event:**
```html
<button data-action="click->hello#greet">Click</button>
```

**Form submit:**
```html
<form data-action="submit->search#filter">
```

**Input change:**
```html
<input data-action="input->filter#search">
```

**Multiple actions:**
```html
<input data-action="focus->form#highlight blur->form#reset">
```

---

## 🔧 Debugging

### Enable Debug Mode

Edit `app/views/layouts/application.html.erb`:

```javascript
window.Stimulus.debug = true  // Change false to true
```

### Console Commands

```javascript
// Check if Stimulus is loaded
Stimulus

// See all registered controllers
Stimulus.router.modulesByIdentifier

// Check controller connections
Stimulus.router.controllersByIdentifier
```

### Check Console Messages

After page load, you should see:
```
Stimulus is ready! Version: 3.2.2
Cart controller registered!
Image gallery controller registered!
Dropdown controller registered!
```

---

## 📚 More Resources

- **Official Docs**: https://stimulus.hotwired.dev/
- **Handbook**: https://stimulus.hotwired.dev/handbook/introduction
- **Reference**: https://stimulus.hotwired.dev/reference/controllers

---

## ✨ Summary

You have **4 working controllers** ready to use:

1. ✅ **cart** - Add products with animations
2. ✅ **image-gallery** - Product image switcher
3. ✅ **dropdown** - Smart dropdown menus
4. ✅ **hello** - Demo/testing

**Just copy the HTML examples into your views and they'll work!**

No build process, no compilation, just refresh your browser! 🎉 