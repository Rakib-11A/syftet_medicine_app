# frozen_string_literal: true

# Simple script to add images to products
puts '��️ Adding images to products...'

# Medical images by category
images_by_category = {
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

default_images = ['medicine-pills.jpg', 'pharmaceutical.jpg', 'medical-product.jpg']

# Process each product
Product.includes(:categories).each do |product|
  next if product.images.any?

  category_name = product.categories.first&.name
  images = images_by_category[category_name] || default_images

  # Add 3 images to each product
  images.first(3).each_with_index do |image_name, index|
    product.images.create!(
      position: index + 1,
      alt: "#{product.name} - #{image_name}",
      content_type: 'image/jpeg',
      width: 400,
      height: 400,
      file_size: rand(50_000..200_000)
    )
  end

  puts "✅ Added images to #{product.name}"
end

puts "🎉 Completed! Total images: #{Image.count}"
