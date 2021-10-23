# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(
   email: "admin@armoiar.com",
   password: "password#",
   role: "admin"
)
#
# Feedback.create(
#     name: 'Roger Fredrick',
#     email: 'roger@ext.com',
#     message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
# )
# 20.times do
#   User.create(
#       email: Faker::Internet.email,
#       name: Faker::Name.first_name,
#       password: "password",
#       role: "admin"
#   )
# end
# 60.times do |index|
#   Admin::Category.create(
#                      name: "Category#{index}"
#   )
# end
# 60.times do |index|
#   Admin::Brand.create(
#                      name: "Brand#{index}",
#                      is_active: true,
#                      image: Faker::Avatar.image
#   )
# end
