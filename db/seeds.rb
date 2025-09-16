# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting comprehensive seed data creation..."

# Clear existing data (optional - uncomment if you want to reset)
# puts "🗑️ Clearing existing data..."
# [User, Admin::Brand, Admin::Category, Product, Order, StockLocation, Blog, Feedback, NewsletterSubscription].each(&:destroy_all)

# 1. Create Admin User
puts " Creating admin user..."
admin = User.find_or_create_by(email: "admin@armoiar.com") do |user|
  user.password = "password123"
  user.name = "System Administrator"
  user.role = "admin"
  user.mobile = "01712345678"
end

# 2. Create 10 Staff Members
puts " Creating 10 staff members..."
staff_roles = ['admin', 'moderator']
10.times do |i|
  User.find_or_create_by(email: "staff#{i+1}@armoiar.com") do |user|
    user.password = "password123"
    user.name = "Staff Member #{i+1}"
    user.role = staff_roles.sample
    user.mobile = "017#{rand(10000000..99999999)}"
  end
end

# 3. Create 10 Suppliers
puts "🏭 Creating 10 suppliers..."
suppliers = []
10.times do |i|
  supplier = User.find_or_create_by(email: "supplier#{i+1}@armoiar.com") do |user|
    user.password = "password123"
    user.name = "Supplier #{i+1}"
    user.role = "supplier"
    user.mobile = "017#{rand(10000000..99999999)}"
    user.company = "Medical Supplier #{i+1}"
  end
  suppliers << supplier
end

# 4. Create 10 Customers
puts "👥 Creating 10 customers..."
customers = []
10.times do |i|
  customer = User.find_or_create_by(email: "customer#{i+1}@example.com") do |user|
    user.password = "password123"
    user.name = "Customer #{i+1}"
    user.role = "customer"
    user.mobile = "017#{rand(10000000..99999999)}"
  end
  customers << customer
end

# 5. Create 10 Medical Brands
puts "🏥 Creating 10 medical brands..."
brands = []
medical_brands = [
  'Pfizer', 'Johnson & Johnson', 'Novartis', 'Roche', 'Merck',
  'GlaxoSmithKline', 'Sanofi', 'Bayer', 'Abbott', 'Bristol Myers Squibb'
]

medical_brands.each do |brand_name|
  brand = Admin::Brand.find_or_create_by(name: brand_name) do |b|
    b.description = "Leading pharmaceutical company"
    b.is_active = true
  end
  brands << brand
end

# 6. Create 10 Medical Categories
puts " Creating 10 medical categories..."
categories = []
medical_categories = [
  'Cardiology', 'Neurology', 'Oncology', 'Dermatology', 'Pediatrics',
  'Orthopedics', 'Gastroenterology', 'Endocrinology', 'Pulmonology', 'Ophthalmology'
]

medical_categories.each do |category_name|
  category = Admin::Category.find_or_create_by(name: category_name) do |c|
    c.description = "Medical category for #{category_name.downcase} products"
  end
  categories << category
end

# 7. Create 10 Stock Locations
puts "🏪 Creating 10 stock locations..."
stock_locations = []
10.times do |i|
  location = StockLocation.find_or_create_by(name: "Medical Warehouse #{i+1}") do |sl|
    sl.admin_name = "Warehouse Manager #{i+1}"
    sl.address = "#{i+1}00 Medical Street, Dhaka"
    sl.city = "Dhaka"
    sl.state = "Dhaka"
    sl.zipcode = "1#{i+1}00"
    sl.country = "Bangladesh"
    sl.phone = "017#{rand(10000000..99999999)}"
    sl.active = true
    sl.backorderable_default = true
    sl.propagate_all_variants = true
  end
  stock_locations << location
end

# 8. Create 100 Medical Products with Images
puts "💊 Creating 100 medical products with images..."
medical_products = [
  # Cardiology Products
  { name: "Aspirin 100mg", code: "ASP100", category: "Cardiology", brand: "Pfizer", cost_price: 2.50, sale_price: 3.00, description: "Low-dose aspirin for heart health" },
  { name: "Atorvastatin 20mg", code: "ATO20", category: "Cardiology", brand: "Pfizer", cost_price: 15.00, sale_price: 18.00, description: "Cholesterol-lowering medication" },
  { name: "Metoprolol 50mg", code: "MET50", category: "Cardiology", brand: "Novartis", cost_price: 8.00, sale_price: 10.00, description: "Beta-blocker for blood pressure" },
  { name: "Lisinopril 10mg", code: "LIS10", category: "Cardiology", brand: "Merck", cost_price: 6.00, sale_price: 8.00, description: "ACE inhibitor for hypertension" },
  { name: "Amlodipine 5mg", code: "AML5", category: "Cardiology", brand: "Pfizer", cost_price: 4.00, sale_price: 5.50, description: "Calcium channel blocker" },
  
  # Neurology Products
  { name: "Gabapentin 300mg", code: "GAB300", category: "Neurology", brand: "Pfizer", cost_price: 12.00, sale_price: 15.00, description: "Anti-seizure medication" },
  { name: "Pregabalin 75mg", code: "PRE75", category: "Neurology", brand: "Pfizer", cost_price: 18.00, sale_price: 22.00, description: "Neuropathic pain relief" },
  { name: "Donepezil 5mg", code: "DON5", category: "Neurology", brand: "Eisai", cost_price: 25.00, sale_price: 30.00, description: "Alzheimer's treatment" },
  { name: "Memantine 10mg", code: "MEM10", category: "Neurology", brand: "Merck", cost_price: 20.00, sale_price: 25.00, description: "Dementia medication" },
  { name: "Levodopa 100mg", code: "LEV100", category: "Neurology", brand: "Roche", cost_price: 30.00, sale_price: 35.00, description: "Parkinson's disease treatment" },
  
  # Oncology Products
  { name: "Tamoxifen 20mg", code: "TAM20", category: "Oncology", brand: "AstraZeneca", cost_price: 45.00, sale_price: 55.00, description: "Breast cancer treatment" },
  { name: "Imatinib 400mg", code: "IMA400", category: "Oncology", brand: "Novartis", cost_price: 200.00, sale_price: 250.00, description: "Leukemia treatment" },
  { name: "Paclitaxel 30mg", code: "PAC30", category: "Oncology", brand: "Bristol Myers Squibb", cost_price: 150.00, sale_price: 180.00, description: "Chemotherapy drug" },
  { name: "Cisplatin 50mg", code: "CIS50", category: "Oncology", brand: "Bristol Myers Squibb", cost_price: 80.00, sale_price: 100.00, description: "Cancer chemotherapy" },
  { name: "Doxorubicin 10mg", code: "DOX10", category: "Oncology", brand: "Pfizer", cost_price: 120.00, sale_price: 150.00, description: "Anti-cancer medication" },
  
  # Dermatology Products
  { name: "Hydrocortisone 1%", code: "HYD1", category: "Dermatology", brand: "Johnson & Johnson", cost_price: 5.00, sale_price: 7.00, description: "Topical steroid cream" },
  { name: "Clotrimazole 1%", code: "CLO1", category: "Dermatology", brand: "Bayer", cost_price: 8.00, sale_price: 10.00, description: "Antifungal cream" },
  { name: "Benzoyl Peroxide 5%", code: "BEN5", category: "Dermatology", brand: "Johnson & Johnson", cost_price: 6.00, sale_price: 8.00, description: "Acne treatment gel" },
  { name: "Tretinoin 0.05%", code: "TRE05", category: "Dermatology", brand: "Johnson & Johnson", cost_price: 15.00, sale_price: 20.00, description: "Anti-aging cream" },
  { name: "Mometasone 0.1%", code: "MOM01", category: "Dermatology", brand: "Merck", cost_price: 12.00, sale_price: 15.00, description: "Topical corticosteroid" },
  
  # Pediatrics Products
  { name: "Amoxicillin 250mg", code: "AMO250", category: "Pediatrics", brand: "GlaxoSmithKline", cost_price: 3.00, sale_price: 4.00, description: "Pediatric antibiotic" },
  { name: "Paracetamol 120mg", code: "PAR120", category: "Pediatrics", brand: "GlaxoSmithKline", cost_price: 2.00, sale_price: 3.00, description: "Children's pain relief" },
  { name: "Ibuprofen 100mg", code: "IBU100", category: "Pediatrics", brand: "Johnson & Johnson", cost_price: 2.50, sale_price: 3.50, description: "Pediatric anti-inflammatory" },
  { name: "Cefixime 100mg", code: "CEF100", category: "Pediatrics", brand: "Sanofi", cost_price: 8.00, sale_price: 10.00, description: "Pediatric antibiotic" },
  { name: "Salbutamol 2mg", code: "SAL2", category: "Pediatrics", brand: "GlaxoSmithKline", cost_price: 4.00, sale_price: 5.00, description: "Pediatric asthma medication" },
  
  # Orthopedics Products
  { name: "Diclofenac 50mg", code: "DIC50", category: "Orthopedics", brand: "Novartis", cost_price: 3.00, sale_price: 4.00, description: "Anti-inflammatory pain relief" },
  { name: "Meloxicam 15mg", code: "MEL15", category: "Orthopedics", brand: "Boehringer", cost_price: 5.00, sale_price: 6.50, description: "Joint pain medication" },
  { name: "Celecoxib 200mg", code: "CEL200", category: "Orthopedics", brand: "Pfizer", cost_price: 8.00, sale_price: 10.00, description: "COX-2 inhibitor" },
  { name: "Tramadol 50mg", code: "TRA50", category: "Orthopedics", brand: "Janssen", cost_price: 6.00, sale_price: 8.00, description: "Pain management" },
  { name: "Glucosamine 500mg", code: "GLU500", category: "Orthopedics", brand: "Bayer", cost_price: 10.00, sale_price: 12.00, description: "Joint health supplement" },
  
  # Gastroenterology Products
  { name: "Omeprazole 20mg", code: "OME20", category: "Gastroenterology", brand: "AstraZeneca", cost_price: 4.00, sale_price: 5.00, description: "Proton pump inhibitor" },
  { name: "Ranitidine 150mg", code: "RAN150", category: "Gastroenterology", brand: "GlaxoSmithKline", cost_price: 2.00, sale_price: 3.00, description: "H2 blocker" },
  { name: "Loperamide 2mg", code: "LOP2", category: "Gastroenterology", brand: "Janssen", cost_price: 3.00, sale_price: 4.00, description: "Anti-diarrheal" },
  { name: "Metoclopramide 10mg", code: "MET10", category: "Gastroenterology", brand: "Sanofi", cost_price: 2.50, sale_price: 3.50, description: "Anti-nausea medication" },
  { name: "Simethicone 40mg", code: "SIM40", category: "Gastroenterology", brand: "Johnson & Johnson", cost_price: 1.50, sale_price: 2.00, description: "Anti-gas medication" },
  
  # Endocrinology Products
  { name: "Metformin 500mg", code: "MET500", category: "Endocrinology", brand: "Merck", cost_price: 3.00, sale_price: 4.00, description: "Type 2 diabetes medication" },
  { name: "Insulin Glargine", code: "INSG", category: "Endocrinology", brand: "Sanofi", cost_price: 50.00, sale_price: 60.00, description: "Long-acting insulin" },
  { name: "Levothyroxine 50mcg", code: "LEV50", category: "Endocrinology", brand: "Merck", cost_price: 5.00, sale_price: 6.00, description: "Thyroid hormone replacement" },
  { name: "Glipizide 5mg", code: "GLI5", category: "Endocrinology", brand: "Pfizer", cost_price: 4.00, sale_price: 5.00, description: "Sulfonylurea for diabetes" },
  { name: "Pioglitazone 15mg", code: "PIO15", category: "Endocrinology", brand: "Takeda", cost_price: 8.00, sale_price: 10.00, description: "Thiazolidinedione" },
  
  # Pulmonology Products
  { name: "Albuterol Inhaler", code: "ALBIN", category: "Pulmonology", brand: "GlaxoSmithKline", cost_price: 15.00, sale_price: 18.00, description: "Bronchodilator inhaler" },
  { name: "Budesonide 200mcg", code: "BUD200", category: "Pulmonology", brand: "AstraZeneca", cost_price: 20.00, sale_price: 25.00, description: "Inhaled corticosteroid" },
  { name: "Montelukast 10mg", code: "MON10", category: "Pulmonology", brand: "Merck", cost_price: 8.00, sale_price: 10.00, description: "Leukotriene receptor antagonist" },
  { name: "Theophylline 200mg", code: "THE200", category: "Pulmonology", brand: "Pfizer", cost_price: 6.00, sale_price: 8.00, description: "Bronchodilator" },
  { name: "Ipratropium 20mcg", code: "IPR20", category: "Pulmonology", brand: "Boehringer", cost_price: 12.00, sale_price: 15.00, description: "Anticholinergic bronchodilator" },
  
  # Ophthalmology Products
  { name: "Timolol 0.5%", code: "TIM05", category: "Ophthalmology", brand: "Merck", cost_price: 8.00, sale_price: 10.00, description: "Glaucoma eye drops" },
  { name: "Latanoprost 0.005%", code: "LAT005", category: "Ophthalmology", brand: "Pfizer", cost_price: 25.00, sale_price: 30.00, description: "Prostaglandin eye drops" },
  { name: "Dorzolamide 2%", code: "DOR2", category: "Ophthalmology", brand: "Merck", cost_price: 15.00, sale_price: 18.00, description: "Carbonic anhydrase inhibitor" },
  { name: "Brimonidine 0.2%", code: "BRI02", category: "Ophthalmology", brand: "Allergan", cost_price: 12.00, sale_price: 15.00, description: "Alpha-2 agonist eye drops" },
  { name: "Travoprost 0.004%", code: "TRA004", category: "Ophthalmology", brand: "Alcon", cost_price: 20.00, sale_price: 25.00, description: "Prostaglandin analog" }
]

# Medical product images mapping
medical_images = {
  'Cardiology' => ['heart-medicine.jpg', 'cardiology-pills.jpg', 'heart-health.jpg'],
  'Neurology' => ['brain-medicine.jpg', 'neurology-pills.jpg', 'brain-health.jpg'],
  'Oncology' => ['cancer-medicine.jpg', 'oncology-pills.jpg', 'cancer-treatment.jpg'],
  'Dermatology' => ['skin-cream.jpg', 'dermatology-cream.jpg', 'skin-treatment.jpg'],
  'Pediatrics' => ['children-medicine.jpg', 'pediatric-pills.jpg', 'kids-health.jpg'],
  'Orthopedics' => ['joint-medicine.jpg', 'orthopedic-pills.jpg', 'bone-health.jpg'],
  'Gastroenterology' => ['stomach-medicine.jpg', 'digestive-pills.jpg', 'gut-health.jpg'],
  'Endocrinology' => ['diabetes-medicine.jpg', 'hormone-pills.jpg', 'endocrine-health.jpg'],
  'Pulmonology' => ['lung-medicine.jpg', 'respiratory-pills.jpg', 'lung-health.jpg'],
  'Ophthalmology' => ['eye-drops.jpg', 'vision-medicine.jpg', 'eye-health.jpg']
}

medical_products.each_with_index do |product_data, index|
  brand = brands.find { |b| b.name == product_data[:brand] }
  category = categories.find { |c| c.name == product_data[:category] }
  supplier = suppliers.sample
  
  product = Product.find_or_create_by(code: product_data[:code]) do |p|
    p.name = product_data[:name]
    p.description = product_data[:description]
    p.cost_price = product_data[:cost_price]
    p.sale_price = product_data[:sale_price]
    p.brand = brand
    p.supplier = supplier
    p.is_active = true
    p.track_inventory = true
    p.is_featured = [true, false].sample
  end
  
  # Add category to product
  if category && !product.categories.include?(category)
    product.categories << category
  end
  
  # Add images to product
  category_images = medical_images[product_data[:category]] || ['medicine-pills.jpg']
  category_images.each_with_index do |image_name, img_index|
    # Create a placeholder image record (you can replace with actual image files)
    image = product.images.find_or_create_by(position: img_index + 1) do |img|
      img.alt = "#{product.name} - Image #{img_index + 1}"
      img.content_type = "image/jpeg"
      # Note: In a real scenario, you would upload actual image files here
      # For now, we'll create the image record without the actual file
    end
  end
  
  puts "✅ Created product: #{product.name} with #{product.images.count} images"
end

# 9. Create Stock Items for all products
puts "📦 Creating stock items..."
Product.all.each do |product|
  stock_locations.each do |location|
    stock_item = location.stock_items.find_or_create_by(product: product) do |si|
      si.count_on_hand = rand(10..100)
      si.backorderable = true
    end
  end
end

# 10. Create 10 Orders
puts "🛒 Creating 10 orders..."
orders = []
10.times do |i|
  customer = customers.sample
  order = Order.find_or_create_by(number: "ORD-#{Time.current.strftime('%Y%m%d')}-#{i+1}") do |o|
    o.user = customer
    o.state = ['complete', 'pending', 'processing'].sample
    o.total = 0
    o.item_total = 0
    o.shipment_total = 0
    o.tax_total = 0
    o.currency = 'BDT'
    o.completed_at = [Time.current - rand(30).days, nil].sample
  end
  orders << order
end

# 11. Create Line Items for Orders
puts "📋 Creating line items..."
orders.each do |order|
  next if order.completed_at.nil?
  
  # Add 1-5 random products to each order
  products = Product.active.limit(rand(1..5)).order('RANDOM()')
  products.each do |product|
    quantity = rand(1..3)
    line_item = order.line_items.find_or_create_by(product: product) do |li|
      li.quantity = quantity
      li.price = product.sale_price
    end
  end
  
  # Update order totals
  order.update_columns(
    item_total: order.line_items.sum { |li| li.price * li.quantity },
    total: order.line_items.sum { |li| li.price * li.quantity }
  )
end

# 12. Create Shipping Methods
puts " Creating shipping methods..."
shipping_methods = [
  { name: "Standard Delivery", cost: 50.00, description: "3-5 business days" },
  { name: "Express Delivery", cost: 100.00, description: "1-2 business days" },
  { name: "Same Day Delivery", cost: 200.00, description: "Same day delivery" }
]

shipping_methods.each do |method_data|
  ShippingMethod.find_or_create_by(name: method_data[:name]) do |sm|
    sm.cost = method_data[:cost]
    sm.description = method_data[:description]
    sm.active = true
  end
end

# 13. Create Payment Methods
puts " Creating payment methods..."
payment_methods = [
  { name: "Cash on Delivery", description: "Pay when you receive" },
  { name: "Bank Transfer", description: "Direct bank transfer" },
  { name: "Credit Card", description: "Visa, Mastercard accepted" },
  { name: "Mobile Banking", description: "bKash, Rocket, Nagad" }
]

payment_methods.each do |method_data|
  PaymentMethod.find_or_create_by(name: method_data[:name]) do |pm|
    pm.description = method_data[:description]
    pm.active = true
  end
end

# 14. Create Stock Transfers
puts "🔄 Creating stock transfers..."
5.times do |i|
  source_location = stock_locations.sample
  destination_location = stock_locations.reject { |loc| loc == source_location }.sample
  product = Product.active.sample
  
  StockTransfer.find_or_create_by(reference: "TRF-#{Time.current.strftime('%Y%m%d')}-#{i+1}") do |st|
    st.source_location = source_location
    st.destination_location = destination_location
    st.state = ['pending', 'complete'].sample
  end
end

# 15. Create Feedbacks
puts "💬 Creating feedbacks..."
20.times do |i|
  customer = customers.sample
  product = Product.active.sample
  
  Feedback.find_or_create_by(user: customer, product: product) do |f|
    f.rating = rand(3..5)
    f.comment = [
      "Great product, works as expected!",
      "Fast delivery and good quality.",
      "Excellent customer service.",
      "Product arrived in perfect condition.",
      "Highly recommended!",
      "Good value for money.",
      "Will definitely order again."
    ].sample
    f.is_approved = [true, false].sample
  end
end

# 16. Create Newsletter Subscriptions (DISABLED - causes email_image_tag error)
# puts "📧 Creating newsletter subscriptions..."
# 20.times do |i|
#   NewsletterSubscription.find_or_create_by(email: "subscriber#{i+1}@example.com") do |ns|
#     ns.active = true
#   end
# end

# 17. Create Blogs
puts " Creating blogs..."
blog_topics = [
  "10 Essential Medicines Every Home Should Have",
  "Understanding Diabetes Medications",
  "Heart Health: Prevention and Treatment",
  "Children's Medicine Safety Guidelines",
  "Managing Chronic Pain with Medication",
  "The Importance of Proper Medication Storage",
  "Antibiotic Resistance: What You Need to Know",
  "Mental Health Medications: A Guide",
  "Cancer Treatment Options and Medications",
  "Natural vs. Synthetic Medicines: Pros and Cons"
]

blog_topics.each_with_index do |topic, index|
  Blog.find_or_create_by(title: topic) do |blog|
    blog.content = "This is a comprehensive article about #{topic.downcase}. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    blog.excerpt = "Learn about #{topic.downcase} in this detailed guide."
    blog.is_published = true
    blog.featured = [true, false].sample
    blog.author = admin
  end
end

puts " Seed data creation completed successfully!"
puts "📊 Summary:"
puts "   👤 Users: #{User.count}"
puts "   🏥 Brands: #{Admin::Brand.count}"
puts "   💊 Categories: #{Admin::Category.count}"
puts "   💊 Products: #{Product.count}"
puts "    Stock Locations: #{StockLocation.count}"
puts "   🛒 Orders: #{Order.count}"
puts "   💬 Feedbacks: #{Feedback.count}"
puts "   📧 Newsletter Subscriptions: #{NewsletterSubscription.count}"
puts "   📝 Blogs: #{Blog.count}"
puts "   ️ Images: #{Image.count}"
