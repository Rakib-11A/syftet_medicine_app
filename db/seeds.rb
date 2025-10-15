puts "Seeding Reviews"
user_id = 1
product_id_1 = 1
product_id_2 = 2
def reviews_time(days_ago)
  Time.current - days_ago.days
end
reviews_data = [
  {
    name: "John Doe",
    email: "john.doe@example.com",
    rating: 5,
    text: "Incredibly Fast Delivery! I got my emergency medicine in under 30 minutes. A true Lifesaver",
    product_id: product_id_1,
    user_id: user_id,
    is_approved: true,
    created_at: reviews_time(5),
    updated_at: reviews_time(5)
  },
  {
    name: "Jane Smith",
    email: "jane.smithy@email.com",
    rating: 4,
    text: "This website is very easy to use and I always find what I need. Great service and genuine products",
    product_id: product_id_2,
    user_id: user_id,
    is_approved: true,
    created_at: reviews_time(10),
    updated_at: reviews_time(10)
  },
  {
    name: "Fahmida Alam",
    email: "fahmida.alam@gmail.com",
    rating: 4,
    text: "I love the prescription upload feature. It saves so much time and hassle. Highly recommend!",
    product_id: product_id_1,
    user_id: user_id,
    is_approved: true,
    created_at: reviews_time(15),
    updated_at: reviews_time(15)
  }
]

reviews_data.each do |review_attributes|
  Review.find_or_create_by!(
    email: review_attributes[:email],
    product_id: review_attributes[:product_id]
  ) do |review|
    review.name = review_attributes[:name]
    review.rating = review_attributes[:rating]
    review.text = review_attributes[:text]
    review.user_id = review_attributes[:user_id]
    review.is_approved = review_attributes[:is_approved]
    puts "Created review for Product ID: #{review.product_id}"
  end
end