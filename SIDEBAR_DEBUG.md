# Sidebar Debug Guide

## Quick Test Steps:

1. **Open your browser and go to your Rails app**
2. **Open Developer Tools (F12)**
3. **Check the Console tab for any errors**
4. **Look for these messages:**
   - "Navigation controller connected!"
   - "Available targets: ..."
   - "Toggle sidebar clicked!" (when you click the hamburger icon)

## Manual Test:

1. **In the browser console, run this code:**
```javascript
// Test if sidebar exists
const sidebar = document.getElementById('sidebar');
console.log('Sidebar found:', sidebar);

// Test if it has the correct classes
if (sidebar) {
  console.log('Current classes:', sidebar.classList.toString());
  
  // Manually toggle the sidebar
  sidebar.classList.toggle('open');
  console.log('After toggle:', sidebar.classList.toString());
}
```

## Common Issues & Solutions:

### Issue 1: Stimulus not loading
**Check:** Look for "Navigation controller connected!" in console
**Solution:** Make sure Stimulus is properly configured

### Issue 2: CSS not applied
**Check:** Inspect the sidebar element and see if CSS is applied
**Solution:** Check if nav_menu.scss is being compiled

### Issue 3: JavaScript errors
**Check:** Look for any red errors in console
**Solution:** Fix JavaScript syntax errors

### Issue 4: Targets not found
**Check:** Look for "Sidebar target not found!" in console
**Solution:** Make sure data-navigation-target="sidebar" is set correctly

## Force Sidebar Visible (for testing):

Add this CSS to force the sidebar visible:
```css
.sidebar {
  left: 0 !important;
  background: red !important;
  border: 2px solid blue !important;
}
```

## Test Button:

There should be a red "Test Sidebar" button on the page. Click it to test the sidebar functionality.
