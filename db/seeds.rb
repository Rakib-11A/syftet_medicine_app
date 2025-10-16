# frozen_string_literal: true

puts '🌱 Starting comprehensive seed data creation...'
puts '=' * 60

# Delete all existing data first
puts "\n🗑️ Clearing all existing data..."

# List of models to clear in correct order
models_to_clear = [
  'ReturnItem', 'CustomerReturn', 'Tracking', 'Shipment', 'LineItem',
  'Payment', 'Refund', 'PaypalExpressCheckout', 'Order', 'Wishlist',
  'Review', 'RewardsPoint', 'StockMovement', 'StockTransfer', 'StockItem',
  'PrintBarcode', 'Print', 'Admin::Suppliers::Discount', 'Admin::Suppliers::RefundItem',
  'Admin::Suppliers::Refund', 'Admin::Suppliers::Payment',
  'Admin::Suppliers::Invoices::Attachment', 'Admin::Suppliers::InvoiceItem',
  'Admin::Suppliers::Invoice', 'Admin::Suppliers::TextMessage', 'Admin::Coupon',
  'Comment', 'Blog', 'Contact', 'Feedback', 'NewsletterSubscription',
  'HomeSlider', 'Admin::GalleryImage', 'Image', 'RelatedProduct',
  'ProductCategory', 'Product', 'Admin::Brand', 'Admin::Category',
  'ShippingMethod', 'PaymentMethod', 'StockLocation', 'Address', 'User'
]

models_to_clear.each do |model_name|
  model = model_name.constantize
  model.destroy_all
  puts "   ✓ Cleared #{model_name}"
rescue NameError
  puts "   ⚠️ Model not found: #{model_name} - skipping"
rescue StandardError => e
  puts "   ⚠️ Could not clear #{model_name}: #{e.message}"
end

puts "\n✅ Database cleared successfully!\n"
puts '=' * 60

# ==================== USERS ====================
puts "\n👤 Creating Users..."

# 1. Admin User
admin = User.create!(
  email: 'admin@armoiar.com',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'System Administrator',
  role: 'admin',
  mobile: '01712345678',
  company: 'Armoiar Medical',
  initial_balance: 0,
  initial_balance_date: Date.today
)
puts "   ✓ Admin: #{admin.email}"

# 2. Staff Members (10)
staff_members = []
staff_roles = %w[admin moderator]
10.times do |i|
  staff = User.create!(
    email: "staff#{i + 1}@armoiar.com",
    password: 'password123',
    password_confirmation: 'password123',
    name: "Staff Member #{i + 1}",
    role: staff_roles.sample,
    mobile: "017#{rand(10_000_000..99_999_999)}"
  )
  staff_members << staff
end
puts '   ✓ Created 10 staff members'

# 3. Suppliers (15)
suppliers = []
15.times do |i|
  supplier = User.create!(
    email: "supplier#{i + 1}@armoiar.com",
    password: 'password123',
    password_confirmation: 'password123',
    name: "Supplier #{i + 1}",
    role: 'supplier',
    mobile: "017#{rand(10_000_000..99_999_999)}",
    company: "Medical Supplier #{i + 1}",
    initial_balance: rand(10_000..50_000),
    initial_balance_date: Date.today - rand(30..90).days
  )
  suppliers << supplier
end
puts '   ✓ Created 15 suppliers'

# 4. Customers (20)
customers = []
20.times do |i|
  customer = User.create!(
    email: "customer#{i + 1}@example.com",
    password: 'password123',
    password_confirmation: 'password123',
    name: "Customer #{i + 1}",
    role: 'customer',
    mobile: "017#{rand(10_000_000..99_999_999)}"
  )
  customers << customer
end
puts '   ✓ Created 20 customers'

# ==================== ADDRESSES ====================
puts "\n📍 Creating Addresses..."
addresses = []
customers.each do |customer|
  address = Address.create!(
    firstname: customer.name.split.first,
    lastname: customer.name.split.last || 'User',
    address: "#{rand(1..999)} Medical Street",
    city: %w[Dhaka Chittagong Sylhet Rajshahi Khulna].sample,
    state: 'Bangladesh',
    zipcode: "1#{rand(100..999)}",
    country: 'Bangladesh',
    phone: customer.mobile,
    company: ''
  )
  addresses << address
  customer.update(ship_address_id: address.id)
end
puts "   ✓ Created #{addresses.count} addresses"

# ==================== BRANDS ====================
puts "\n🏥 Creating Medical Brands..."
brands = []
medical_brands = [
  'Pfizer', 'Johnson & Johnson', 'Novartis', 'Roche', 'Merck',
  'GlaxoSmithKline', 'Sanofi', 'Bayer', 'Abbott', 'Bristol Myers Squibb',
  'AstraZeneca', 'Eli Lilly', 'Boehringer Ingelheim', 'Teva', 'Takeda'
]

medical_brands.each do |brand_name|
  brand = Admin::Brand.create!(
    name: brand_name,
    slug: brand_name.parameterize,
    description: "Leading pharmaceutical company - #{brand_name}",
    is_active: true,
    meta_title: brand_name,
    meta_desc: "#{brand_name} pharmaceutical products",
    keywords: "#{brand_name}, medicine, pharmaceutical"
  )
  brands << brand
end
puts "   ✓ Created #{brands.count} brands"

# ==================== CATEGORIES ====================
puts "\n📁 Creating Medical Categories..."
categories = []
medical_categories = [
  { name: 'Cardiology', desc: 'Heart and cardiovascular medicines' },
  { name: 'Neurology', desc: 'Brain and nervous system medications' },
  { name: 'Oncology', desc: 'Cancer treatment medications' },
  { name: 'Dermatology', desc: 'Skin care and treatment products' },
  { name: 'Pediatrics', desc: 'Children\'s medicines and healthcare' },
  { name: 'Orthopedics', desc: 'Bone and joint medications' },
  { name: 'Gastroenterology', desc: 'Digestive system medications' },
  { name: 'Endocrinology', desc: 'Hormone and diabetes medications' },
  { name: 'Pulmonology', desc: 'Respiratory system medications' },
  { name: 'Ophthalmology', desc: 'Eye care medications' },
  { name: 'Antibiotics', desc: 'Bacterial infection treatments' },
  { name: 'Pain Relief', desc: 'Pain management medications' }
]

medical_categories.each do |cat_data|
  category = Admin::Category.create!(
    name: cat_data[:name],
    slug: cat_data[:name].parameterize,
    description: cat_data[:desc],
    meta_title: cat_data[:name],
    meta_desc: cat_data[:desc],
    keywords: cat_data[:name].downcase
  )
  categories << category
end
puts "   ✓ Created #{categories.count} categories"

# ==================== STOCK LOCATIONS ====================
puts "\n🏪 Creating Stock Locations..."
stock_locations = []
locations_data = [
  { name: 'Main Warehouse', city: 'Dhaka', address: '100 Medical Plaza', state: 'Dhaka Division' },
  { name: 'Secondary Warehouse', city: 'Chittagong', address: '200 Hospital Road', state: 'Chittagong Division' },
  { name: 'Retail Store 1', city: 'Dhaka', address: '50 Pharmacy Street', state: 'Dhaka Division' },
  { name: 'Retail Store 2', city: 'Sylhet', address: '75 Health Avenue', state: 'Sylhet Division' },
  { name: 'Distribution Center', city: 'Rajshahi', address: '125 Medical Complex', state: 'Rajshahi Division' }
]

locations_data.each_with_index do |loc_data, i|
  location = StockLocation.create!(
    name: loc_data[:name],
    admin_name: "Manager #{i + 1}",
    address: loc_data[:address],
    city: loc_data[:city],
    state: loc_data[:state],
    zipcode: "1#{rand(100..999)}",
    country: 'Bangladesh',
    phone: "017#{rand(10_000_000..99_999_999)}",
    active: true,
    default: i.zero?,
    backorderable_default: true,
    propagate_all_variants: true
  )
  stock_locations << location
end
puts "   ✓ Created #{stock_locations.count} stock locations"

# ==================== PRODUCTS ====================
puts "\n💊 Creating Medical Products..."
medical_products = [
  # Cardiology
  { name: 'Aspirin 100mg', code: 'ASP100', category: 'Cardiology', brand: 'Pfizer', cost: 2.50, sale: 3.50,
    desc: 'Low-dose aspirin for heart health' },
  { name: 'Atorvastatin 20mg', code: 'ATO20', category: 'Cardiology', brand: 'Pfizer', cost: 15.00, sale: 20.00,
    desc: 'Cholesterol-lowering medication' },
  { name: 'Metoprolol 50mg', code: 'MET50', category: 'Cardiology', brand: 'Novartis', cost: 8.00, sale: 12.00,
    desc: 'Beta-blocker for blood pressure' },
  { name: 'Lisinopril 10mg', code: 'LIS10', category: 'Cardiology', brand: 'Merck', cost: 6.00, sale: 9.00,
    desc: 'ACE inhibitor for hypertension' },
  { name: 'Amlodipine 5mg', code: 'AML5', category: 'Cardiology', brand: 'Pfizer', cost: 4.00, sale: 6.00,
    desc: 'Calcium channel blocker' },

  # Neurology
  { name: 'Gabapentin 300mg', code: 'GAB300', category: 'Neurology', brand: 'Pfizer', cost: 12.00, sale: 18.00,
    desc: 'Anti-seizure medication' },
  { name: 'Pregabalin 75mg', code: 'PRE75', category: 'Neurology', brand: 'Pfizer', cost: 18.00, sale: 25.00,
    desc: 'Neuropathic pain relief' },
  { name: 'Donepezil 5mg', code: 'DON5', category: 'Neurology', brand: 'Roche', cost: 25.00, sale: 35.00,
    desc: "Alzheimer's treatment" },
  { name: 'Memantine 10mg', code: 'MEM10', category: 'Neurology', brand: 'Merck', cost: 20.00, sale: 28.00,
    desc: 'Dementia medication' },
  { name: 'Levodopa 100mg', code: 'LEV100', category: 'Neurology', brand: 'Roche', cost: 30.00, sale: 40.00,
    desc: "Parkinson's disease treatment" },

  # Oncology
  { name: 'Tamoxifen 20mg', code: 'TAM20', category: 'Oncology', brand: 'AstraZeneca', cost: 45.00, sale: 60.00,
    desc: 'Breast cancer treatment' },
  { name: 'Imatinib 400mg', code: 'IMA400', category: 'Oncology', brand: 'Novartis', cost: 200.00, sale: 280.00,
    desc: 'Leukemia treatment' },
  { name: 'Paclitaxel 30mg', code: 'PAC30', category: 'Oncology', brand: 'Bristol Myers Squibb', cost: 150.00,
    sale: 210.00, desc: 'Chemotherapy drug' },
  { name: 'Cisplatin 50mg', code: 'CIS50', category: 'Oncology', brand: 'Bristol Myers Squibb', cost: 80.00,
    sale: 110.00, desc: 'Cancer chemotherapy' },
  { name: 'Doxorubicin 10mg', code: 'DOX10', category: 'Oncology', brand: 'Pfizer', cost: 120.00, sale: 165.00,
    desc: 'Anti-cancer medication' },

  # Dermatology
  { name: 'Hydrocortisone 1%', code: 'HYD1', category: 'Dermatology', brand: 'Johnson & Johnson', cost: 5.00,
    sale: 8.00, desc: 'Topical steroid cream' },
  { name: 'Clotrimazole 1%', code: 'CLO1', category: 'Dermatology', brand: 'Bayer', cost: 8.00, sale: 12.00,
    desc: 'Antifungal cream' },
  { name: 'Benzoyl Peroxide 5%', code: 'BEN5', category: 'Dermatology', brand: 'Johnson & Johnson', cost: 6.00,
    sale: 10.00, desc: 'Acne treatment gel' },
  { name: 'Tretinoin 0.05%', code: 'TRE05', category: 'Dermatology', brand: 'Johnson & Johnson', cost: 15.00,
    sale: 22.00, desc: 'Anti-aging cream' },
  { name: 'Mometasone 0.1%', code: 'MOM01', category: 'Dermatology', brand: 'Merck', cost: 12.00, sale: 18.00,
    desc: 'Topical corticosteroid' },

  # Pediatrics
  { name: 'Amoxicillin 250mg', code: 'AMO250', category: 'Pediatrics', brand: 'GlaxoSmithKline', cost: 3.00,
    sale: 5.00, desc: 'Pediatric antibiotic' },
  { name: 'Paracetamol 120mg', code: 'PAR120', category: 'Pediatrics', brand: 'GlaxoSmithKline', cost: 2.00,
    sale: 3.50, desc: "Children's pain relief" },
  { name: 'Ibuprofen 100mg', code: 'IBU100', category: 'Pediatrics', brand: 'Johnson & Johnson', cost: 2.50,
    sale: 4.00, desc: 'Pediatric anti-inflammatory' },
  { name: 'Cefixime 100mg', code: 'CEF100', category: 'Pediatrics', brand: 'Sanofi', cost: 8.00, sale: 12.00,
    desc: 'Pediatric antibiotic' },
  { name: 'Salbutamol 2mg', code: 'SAL2', category: 'Pediatrics', brand: 'GlaxoSmithKline', cost: 4.00, sale: 6.50,
    desc: 'Pediatric asthma medication' },

  # Orthopedics & Pain Relief
  { name: 'Diclofenac 50mg', code: 'DIC50', category: 'Pain Relief', brand: 'Novartis', cost: 3.00, sale: 5.00,
    desc: 'Anti-inflammatory pain relief' },
  { name: 'Meloxicam 15mg', code: 'MEL15', category: 'Orthopedics', brand: 'Bayer', cost: 5.00, sale: 8.00,
    desc: 'Joint pain medication' },
  { name: 'Celecoxib 200mg', code: 'CEL200', category: 'Orthopedics', brand: 'Pfizer', cost: 8.00, sale: 12.00,
    desc: 'COX-2 inhibitor' },
  { name: 'Tramadol 50mg', code: 'TRA50', category: 'Pain Relief', brand: 'Abbott', cost: 6.00, sale: 9.50,
    desc: 'Pain management' },
  { name: 'Glucosamine 500mg', code: 'GLU500', category: 'Orthopedics', brand: 'Bayer', cost: 10.00, sale: 15.00,
    desc: 'Joint health supplement' },

  # Gastroenterology
  { name: 'Omeprazole 20mg', code: 'OME20', category: 'Gastroenterology', brand: 'AstraZeneca', cost: 4.00, sale: 6.50,
    desc: 'Proton pump inhibitor' },
  { name: 'Ranitidine 150mg', code: 'RAN150', category: 'Gastroenterology', brand: 'GlaxoSmithKline', cost: 2.00,
    sale: 3.50, desc: 'H2 blocker' },
  { name: 'Loperamide 2mg', code: 'LOP2', category: 'Gastroenterology', brand: 'Abbott', cost: 3.00, sale: 5.00,
    desc: 'Anti-diarrheal' },
  { name: 'Metoclopramide 10mg', code: 'MET10G', category: 'Gastroenterology', brand: 'Sanofi', cost: 2.50, sale: 4.00,
    desc: 'Anti-nausea medication' },
  { name: 'Simethicone 40mg', code: 'SIM40', category: 'Gastroenterology', brand: 'Johnson & Johnson', cost: 1.50,
    sale: 2.50, desc: 'Anti-gas medication' },

  # Endocrinology
  { name: 'Metformin 500mg', code: 'MET500', category: 'Endocrinology', brand: 'Merck', cost: 3.00, sale: 5.00,
    desc: 'Type 2 diabetes medication' },
  { name: 'Insulin Glargine 100U', code: 'INSG', category: 'Endocrinology', brand: 'Sanofi', cost: 50.00, sale: 70.00,
    desc: 'Long-acting insulin' },
  { name: 'Levothyroxine 50mcg', code: 'LEV50E', category: 'Endocrinology', brand: 'Merck', cost: 5.00, sale: 8.00,
    desc: 'Thyroid hormone replacement' },
  { name: 'Glipizide 5mg', code: 'GLI5', category: 'Endocrinology', brand: 'Pfizer', cost: 4.00, sale: 6.50,
    desc: 'Sulfonylurea for diabetes' },
  { name: 'Pioglitazone 15mg', code: 'PIO15', category: 'Endocrinology', brand: 'Takeda', cost: 8.00, sale: 12.00,
    desc: 'Thiazolidinedione' },

  # Pulmonology
  { name: 'Albuterol Inhaler', code: 'ALBIN', category: 'Pulmonology', brand: 'GlaxoSmithKline', cost: 15.00,
    sale: 22.00, desc: 'Bronchodilator inhaler' },
  { name: 'Budesonide 200mcg', code: 'BUD200', category: 'Pulmonology', brand: 'AstraZeneca', cost: 20.00, sale: 30.00,
    desc: 'Inhaled corticosteroid' },
  { name: 'Montelukast 10mg', code: 'MON10', category: 'Pulmonology', brand: 'Merck', cost: 8.00, sale: 12.50,
    desc: 'Leukotriene receptor antagonist' },
  { name: 'Theophylline 200mg', code: 'THE200', category: 'Pulmonology', brand: 'Pfizer', cost: 6.00, sale: 9.00,
    desc: 'Bronchodilator' },
  { name: 'Ipratropium 20mcg', code: 'IPR20', category: 'Pulmonology', brand: 'Boehringer Ingelheim', cost: 12.00,
    sale: 18.00, desc: 'Anticholinergic bronchodilator' },

  # Ophthalmology
  { name: 'Timolol 0.5%', code: 'TIM05', category: 'Ophthalmology', brand: 'Merck', cost: 8.00, sale: 12.00,
    desc: 'Glaucoma eye drops' },
  { name: 'Latanoprost 0.005%', code: 'LAT005', category: 'Ophthalmology', brand: 'Pfizer', cost: 25.00, sale: 35.00,
    desc: 'Prostaglandin eye drops' },
  { name: 'Dorzolamide 2%', code: 'DOR2', category: 'Ophthalmology', brand: 'Merck', cost: 15.00, sale: 22.00,
    desc: 'Carbonic anhydrase inhibitor' },
  { name: 'Brimonidine 0.2%', code: 'BRI02', category: 'Ophthalmology', brand: 'Abbott', cost: 12.00, sale: 18.00,
    desc: 'Alpha-2 agonist eye drops' },
  { name: 'Travoprost 0.004%', code: 'TRA004', category: 'Ophthalmology', brand: 'Novartis', cost: 20.00, sale: 30.00,
    desc: 'Prostaglandin analog' },

  # Antibiotics
  { name: 'Azithromycin 500mg', code: 'AZI500', category: 'Antibiotics', brand: 'Pfizer', cost: 10.00, sale: 15.00,
    desc: 'Broad-spectrum antibiotic' },
  { name: 'Ciprofloxacin 500mg', code: 'CIP500', category: 'Antibiotics', brand: 'Bayer', cost: 8.00, sale: 12.00,
    desc: 'Fluoroquinolone antibiotic' }
]

products = []
medical_products.each do |prod_data|
  brand = brands.find { |b| b.name == prod_data[:brand] }
  category = categories.find { |c| c.name == prod_data[:category] }
  supplier = suppliers.sample

  product = Product.create!(
    name: prod_data[:name],
    code: prod_data[:code],
    barcode: "BR#{prod_data[:code]}",
    description: prod_data[:desc],
    cost_price: prod_data[:cost],
    sale_price: prod_data[:sale],
    whole_sale: prod_data[:cost] * 1.2,
    brand: brand,
    supplier: supplier,
    is_active: true,
    is_featured: [true, false].sample,
    track_inventory: true,
    discountable: true,
    discount: [0, 5, 10].sample,
    is_amount: false,
    reward_point: prod_data[:sale] * 0.02,
    min_stock: rand(5..20),
    slug: prod_data[:name].parameterize,
    meta_title: prod_data[:name],
    meta_desc: prod_data[:desc],
    keywords: prod_data[:name].downcase
  )

  product.categories << category if category
  products << product
end
puts "   ✓ Created #{products.count} products"

# ==================== STOCK ITEMS ====================
puts "\n📦 Creating Stock Items..."
stock_item_count = 0
products.each do |product|
  stock_locations.each do |location|
    # Check if stock item already exists
    existing = StockItem.find_by(product: product, stock_location: location)

    if existing
      # Update existing stock item
      existing.update!(
        count_on_hand: rand(20..200),
        backorderable: true
      )
    else
      # Create new stock item
      StockItem.create!(
        product: product,
        stock_location: location,
        count_on_hand: rand(20..200),
        backorderable: true
      )
    end
    stock_item_count += 1
  end
end
puts "   ✓ Created/Updated #{stock_item_count} stock items"

# ==================== SHIPPING & PAYMENT METHODS ====================
puts "\n🚚 Creating Shipping Methods..."
shipping_methods_data = [
  { name: 'Standard Delivery', rate: '50.00', admin_name: 'Standard', code: 'STD' },
  { name: 'Express Delivery', rate: '100.00', admin_name: 'Express', code: 'EXP' },
  { name: 'Same Day Delivery', rate: '200.00', admin_name: 'Same Day', code: 'SMD' },
  { name: 'Store Pickup', rate: '0.00', admin_name: 'Pickup', code: 'PCK' }
]

shipping_methods = []
shipping_methods_data.each do |method_data|
  method = ShippingMethod.create!(
    name: method_data[:name],
    admin_name: method_data[:admin_name],
    code: method_data[:code],
    rate: method_data[:rate],
    display_on: 'both',
    backdoor_only: false
  )
  shipping_methods << method
end
puts "   ✓ Created #{shipping_methods.count} shipping methods"

puts "\n💳 Creating Payment Methods..."
payment_methods_data = [
  { name: 'Cash on Delivery', desc: 'Pay when you receive' },
  { name: 'Bank Transfer', desc: 'Direct bank transfer' },
  { name: 'Credit Card', desc: 'Visa, Mastercard' },
  { name: 'Mobile Banking', desc: 'bKash, Rocket, Nagad' }
]

payment_methods = []
payment_methods_data.each do |method_data|
  method = PaymentMethod.create!(
    name: method_data[:name],
    description: method_data[:desc],
    active: true
  )
  payment_methods << method
end
puts "   ✓ Created #{payment_methods.count} payment methods"

# ==================== COUPONS ====================
puts "\n🎟️ Creating Coupons..."
coupons_data = [
  { code: 'WELCOME10', name: 'Welcome Discount', discount: 0, percentage: 10, max_limit: 100 },
  { code: 'SAVE20', name: 'Save 20%', discount: 0, percentage: 20, max_limit: 50 },
  { code: 'FLAT500', name: 'Flat 500 Taka Off', discount: 500, percentage: 0, max_limit: 200 },
  { code: 'NEWYEAR', name: 'New Year Special', discount: 0, percentage: 15, max_limit: 150 }
]

coupons = []
coupons_data.each do |coupon_data|
  coupon = Admin::Coupon.create!(
    code: coupon_data[:code],
    name: coupon_data[:name],
    discount: coupon_data[:discount],
    percentage: coupon_data[:percentage],
    maximun_limit: coupon_data[:max_limit],
    maximum_limit_count: 0,
    expiration: Date.today + 90.days
  )
  coupons << coupon
end
puts "   ✓ Created #{coupons.count} coupons"

# ==================== ORDERS ====================
puts "\n🛒 Creating Orders..."
order_states = %w[complete processing pending shipped]
line_item_count = 0

# Create a default store (StockLocation) if it doesn't exist
default_store = nil
begin
  default_store = StockLocation.where(name: 'Main Store').first_or_create!(
    name: 'Main Store',
    admin_name: 'Main Store Admin',
    default: true,
    active: true
  )
  puts '   ✓ Created/found default store (StockLocation)'
rescue StandardError => e
  ruts "   ⚠️ Error creating StockLocation: #{e.message}"
end

30.times do |i|
  customer = customers.sample
  state = order_states.sample

  order_params = {
    user: customer,
    number: "ORD#{Time.current.strftime('%Y%m%d')}#{1000 + i}",
    state: state,
    email: customer.email,
    currency: 'BDT',
    item_total: 0,
    shipment_total: rand(0..200),
    tax_total: 0,
    promo_total: 0,
    total: 0,
    payment_state: state == 'complete' ? 'paid' : 'pending',
    shipment_state: state == 'shipped' ? 'shipped' : 'pending',
    completed_at: state == 'complete' ? Time.current - rand(1..30).days : nil,
    ship_address_id: customer.ship_address_id,
    guest_token: SecureRandom.hex(10),
    item_count: 0,
    shipment_progress: state == 'shipped' ? 100 : rand(0..50),
    coupon_id: [nil, coupons.sample&.id].sample
  }

  # Add store_id if store exists
  order_params[:store_id] = default_store.id if default_store

  order = Order.create!(order_params)

  # Add line items
  num_items = rand(2..6)
  num_items.times do
    product = products.sample
    quantity = rand(1..5)

    LineItem.create!(
      order: order,
      variant_id: product.id,
      quantity: quantity,
      price: product.sale_price,
      cost_price: product.cost_price,
      currency: 'BDT'
    )
    line_item_count += 1
  end

  # Update order totals
  items_total = order.line_items.sum { |li| li.price * li.quantity }
  order.update!(
    item_total: items_total,
    item_count: order.line_items.sum(:quantity),
    total: items_total + order.shipment_total - order.promo_total
  )

  # Create shipment for complete orders
  if %w[complete shipped].include?(state)
    Shipment.create!(
      order: order,
      number: "SHP#{order.number}",
      tracking: "TRK#{rand(100_000..999_999)}",
      state: state == 'shipped' ? 'shipped' : 'ready',
      stock_location: stock_locations.first,
      address_id: order.ship_address_id,
      shipping_method: shipping_methods.sample,
      cost: order.shipment_total,
      shipped_at: state == 'shipped' ? Time.current - rand(1..10).days : nil
    )
  end

  # Create payment
  Payment.create!(
    order: order,
    payment_method: payment_methods.sample,
    amount: order.total,
    state: order.payment_state,
    number: "PAY#{order.number}"
  )
end
puts "   ✓ Created #{Order.count} orders with #{line_item_count} line items"

# ==================== SUPPLIER INVOICES ====================
puts "\n📄 Creating Supplier Invoices..."
invoice_count = 0
suppliers.first(5).each do |supplier|
  2.times do |i|
    is_received = [true, false].sample
    invoice = Admin::Suppliers::Invoice.create!(
      supplier: supplier,
      no: "INV#{supplier.id}#{Time.current.strftime('%Y%m')}#{i + 1}",
      amount: 0,
      date: Date.today - rand(10..60).days,
      expected_delivery: Date.today + rand(3..15).days,
      transport_cost: rand(100..500),
      is_complete: [true, false].sample,
      is_received: is_received,
      receive_date: is_received ? (Date.today - rand(1..30).days) : nil,
      is_order: true,
      order_state: %w[pending approved delivered].sample,
      issued_by_id: staff_members.sample.id,
      received_by_id: staff_members.sample.id,
      stock_location: stock_locations.first,
      instruction: 'Please deliver carefully'
    )

    # Add invoice items
    rand(3..8).times do
      product = products.sample
      quantity = rand(10..100)

      Admin::Suppliers::InvoiceItem.create!(
        invoice: invoice,
        product: product,
        issued_quantity: quantity,
        received_quantity: invoice.is_received ? quantity : 0,
        cost_price: product.cost_price,
        sale_price: product.sale_price,
        vat: product.cost_price * 0.05,
        total: product.cost_price * quantity,
        expaire_date: Date.today + rand(365..1095).days
      )
    end

    # Update invoice amount
    invoice.update!(
      amount: invoice.invoice_items.sum(:total)
    )
    invoice_count += 1
  rescue NameError => e
    puts '   ⚠️ Supplier Invoice model not found - skipping'
    break
  end
end
puts "   ✓ Created #{invoice_count} supplier invoices" if invoice_count.positive?

# ==================== SUPPLIER PAYMENTS ====================
puts "\n💰 Creating Supplier Payments..."
payment_count = 0
# Get all created invoices
all_invoices = Admin::Suppliers::Invoice.all.to_a
if all_invoices.any?
  suppliers.first(5).each do |supplier|
    # Get invoices for this supplier
    supplier_invoices = all_invoices.select { |inv| inv.supplier_id == supplier.id }
    next if supplier_invoices.empty?

    rand(1..3).times do
      invoice = supplier_invoices.sample
      Admin::Suppliers::Payment.create!(
        supplier: supplier,
        invoice: invoice,
        paid_by_id: staff_members.sample.id,
        method: %w[cash bank_transfer cheque].sample,
        amount: rand(5000..50_000),
        payment_date: Date.today - rand(1..60).days,
        value_date: Date.today - rand(1..60).days,
        status: %w[pending completed].sample,
        confirmed: [true, false].sample,
        paid_to: supplier.name,
        commission: rand(0..500)
      )
      payment_count += 1
    rescue NameError => e
      puts '   ⚠️ Supplier Payment model not found - skipping'
      break
    end
  end
else
  puts '   ⚠️ No invoices found - skipping payments'
end
puts "   ✓ Created #{payment_count} supplier payments" if payment_count.positive?

# ==================== REVIEWS ====================
puts "\n⭐ Creating Product Reviews..."
review_count = 0
products.sample(20).each do |product|
  rand(1..5).times do
    customer = customers.sample
    Review.create!(
      product: product,
      user: customer,
      name: customer.name,
      email: customer.email,
      rating: rand(3..5),
      text: [
        'Great product! Highly recommended.',
        'Works as expected. Good quality.',
        'Fast delivery and excellent service.',
        'Very satisfied with this purchase.',
        'Good value for money.',
        'Effective medication, will buy again.'
      ].sample,
      is_approved: [true, false].sample
    )
    review_count += 1
  end
end
puts "   ✓ Created #{review_count} reviews"

# ==================== WISHLISTS ====================
puts "\n❤️ Creating Wishlists..."
wishlist_count = 0
customers.each do |customer|
  products.sample(rand(2..8)).each do |product|
    # Check if wishlist item already exists
    next if Wishlist.exists?(user: customer, product: product)

    Wishlist.create!(
      user: customer,
      product: product
    )
    wishlist_count += 1
  end
end
puts "   ✓ Created #{wishlist_count} wishlist items"

# ==================== BLOGS ====================
puts "\n📝 Creating Blogs..."

blogs = []
# Skip blog creation as it requires actual file upload for cover_photo
puts '   ⚠️ Skipping blog creation - requires file upload for cover_photo'
puts "   ✓ Created #{blogs.count} blogs"

# ==================== COMMENTS ====================
puts "\n💬 Creating Blog Comments..."
comment_count = 0
blogs.each do |blog|
  rand(2..6).times do
    Comment.create!(
      blog: blog,
      user: customers.sample,
      body: [
        'Very informative article! Thanks for sharing.',
        'This helped me understand the topic better.',
        'Great explanation. Keep posting such content.',
        'Interesting read. Looking forward to more.',
        'Well written and easy to understand.'
      ].sample,
      is_approved: [true, false].sample
    )
    comment_count += 1
  end
end
puts "   ✓ Created #{comment_count} comments"

# ==================== CONTACTS ====================
puts "\n📧 Creating Contact Messages..."
contact_count = 0
20.times do
  customer = customers.sample
  is_checked = [true, false].sample
  contact_params = {
    full_name: customer.name,
    email: customer.email,
    phone: customer.mobile,
    order_number: Order.where(user: customer).sample&.number,
    inquiry_type: %w[product order delivery general].sample,
    message: 'I have a question about...',
    is_checked: is_checked,
    user_id: staff_members.sample.id # checked_by is required
  }

  Contact.create!(contact_params)
  contact_count += 1
end
puts "   ✓ Created #{contact_count} contact messages"

# ==================== FEEDBACKS ====================
puts "\n📋 Creating Feedbacks..."
feedback_count = 0
customers.sample(15).each do |customer|
  is_checked = [true, false].sample
  feedback_params = {
    name: customer.name,
    email: customer.email,
    feedback_type: %w[product service website delivery].sample,
    message: 'Overall experience was good.',
    product_quality: %w[excellent good average].sample,
    product_price: %w[expensive reasonable cheap].sample,
    customer_service: 'Helpful and responsive staff',
    rate: rand(3..5),
    is_checked: is_checked,
    user_id: staff_members.sample.id # checked_by is required
  }

  Feedback.create!(feedback_params)
  feedback_count += 1
end
puts "   ✓ Created #{feedback_count} feedbacks"

# ==================== NEWSLETTER SUBSCRIPTIONS ====================
puts "\n📬 Creating Newsletter Subscriptions..."
subscription_count = 0
30.times do |i|
  email = "subscriber#{i + 1}@example.com"
  next if NewsletterSubscription.exists?(email: email)

  NewsletterSubscription.create!(
    email: email,
    active: [true, false].sample
  )
  subscription_count += 1
end
puts "   ✓ Created #{subscription_count} newsletter subscriptions"

# ==================== HOME SLIDERS ====================
puts "\n🖼️ Creating Home Sliders..."

sliders = []
# Skip slider creation as it requires file upload for image
puts '   ⚠️ Skipping home slider creation - requires file upload for image'
puts "   ✓ Created #{sliders.count} home sliders"

# ==================== STOCK TRANSFERS ====================
puts "\n🔄 Creating Stock Transfers..."
transfer_count = 0
10.times do |i|
  source = stock_locations.sample
  destination = stock_locations.reject { |loc| loc == source }.sample

  StockTransfer.create!(
    transfer_type: %w[internal external].sample,
    reference: "STF#{Time.current.strftime('%Y%m%d')}#{1000 + i}",
    source_location_id: source.id,
    destination_location_id: destination.id,
    number: "TRF#{1000 + i}"
  )
  transfer_count += 1
end
puts "   ✓ Created #{transfer_count} stock transfers"

# ==================== STOCK MOVEMENTS ====================
puts "\n📊 Creating Stock Movements..."
movement_count = 0
StockItem.limit(50).each do |stock_item|
  rand(1..3).times do
    StockMovement.create!(
      stock_item: stock_item,
      quantity: rand(-10..20),
      action: %w[sold received returned damaged].sample,
      originator_type: 'Order',
      originator_id: Order.all.sample&.id
    )
    movement_count += 1
  end
end
puts "   ✓ Created #{movement_count} stock movements"

# ==================== REWARDS POINTS ====================
puts "\n🎁 Creating Rewards Points..."
points_count = 0
customers.each do |customer|
  customer_orders = Order.where(user: customer, state: 'complete')
  customer_orders.each do |order|
    RewardsPoint.create!(
      user: customer,
      order: order,
      points: order.total * 0.01,
      reason: 'Order completed'
    )
    points_count += 1
  end
end
puts "   ✓ Created #{points_count} rewards points"

# ==================== RELATED PRODUCTS ====================
puts "\n🔗 Creating Related Products..."
related_count = 0
products.sample(20).each do |product|
  same_category_products = product.categories.first&.products&.where&.not(id: product.id) || []
  same_category_products.sample([3, same_category_products.count].min).each do |related|
    # Check if related product already exists
    next if RelatedProduct.exists?(product_id: product.id, relative_id: related.id)

    RelatedProduct.create!(
      product_id: product.id,
      relative_id: related.id
    )
    related_count += 1
  end
end
puts "   ✓ Created #{related_count} related products"

# ==================== PRINT BARCODES ====================
puts "\n🏷️ Creating Print Barcodes..."
print = Print.create!
barcode_count = 0
products.sample(10).each do |product|
  PrintBarcode.create!(
    print: print,
    product: product,
    user: staff_members.sample,
    quantity: rand(10..100)
  )
  barcode_count += 1
end
puts "   ✓ Created #{barcode_count} print barcodes"

# ==================== SUMMARY ====================
puts "\n#{'=' * 60}"
puts '✅ SEED DATA CREATION COMPLETED SUCCESSFULLY!'
puts '=' * 60
puts "\n📊 FINAL SUMMARY:"
puts '-' * 60
puts "   👤 Users: #{User.count}"
puts "      ├─ Admins: #{User.where(role: 'admin').count}"
puts "      ├─ Suppliers: #{User.where(role: 'supplier').count}"
puts "      └─ Customers: #{User.where(role: 'customer').count}"
puts "\n   📍 Addresses: #{Address.count}"
puts "\n   🏥 Brands: #{Admin::Brand.count}"
puts "   📁 Categories: #{Admin::Category.count}"
puts "   💊 Products: #{Product.count}"
puts "   🔗 Related Products: #{RelatedProduct.count}"
puts "\n   🏪 Stock Locations: #{StockLocation.count}"
puts "   📦 Stock Items: #{StockItem.count}"
puts "   📊 Stock Movements: #{StockMovement.count}"
puts "   🔄 Stock Transfers: #{StockTransfer.count}"
puts "\n   🛒 Orders: #{Order.count}"
puts "   📋 Line Items: #{LineItem.count}"
puts "   📦 Shipments: #{Shipment.count}"
puts "   💳 Payments: #{Payment.count}"
puts "\n   🚚 Shipping Methods: #{ShippingMethod.count}"
puts "   💳 Payment Methods: #{PaymentMethod.count}"
puts "   🎟️ Coupons: #{Admin::Coupon.count}"
puts "\n   📄 Supplier Invoices: #{begin; Admin::Suppliers::Invoice.count; rescue StandardError; 0; end}"
puts "   💰 Supplier Payments: #{begin; Admin::Suppliers::Payment.count; rescue StandardError; 0; end}"
puts "\n   ⭐ Reviews: #{Review.count}"
puts "   ❤️ Wishlists: #{Wishlist.count}"
puts "   🎁 Rewards Points: #{RewardsPoint.count}"
puts "\n   📝 Blogs: #{Blog.count}"
puts "   💬 Comments: #{Comment.count}"
puts "\n   📧 Contacts: #{Contact.count}"
puts "   📋 Feedbacks: #{Feedback.count}"
puts "   📬 Newsletter Subscriptions: #{NewsletterSubscription.count}"
puts "\n   🖼️ Home Sliders: #{HomeSlider.count}"
puts "   🏷️ Print Barcodes: #{PrintBarcode.count}"
puts '-' * 60
puts "\n🎉 All seed data has been created successfully!"
puts '📧 Admin Login: admin@armoiar.com'
puts '🔑 Password: password123'
puts '=' * 60
