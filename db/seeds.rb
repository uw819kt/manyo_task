# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  admin: true
)

normal_user = User.create!(
  name: "Normal User",
  email: "normal@example.com",
  password: "password",
  password_confirmation: "password",
  admin: false
)

50.times do
  admin_user.tasks.create(
    title: "Admin_task#{rand(100)}",
    content: "task_content#{n}",
    deadline_on: Faker::Date.between(from: Date.today, to: 1.month.from_now),
    priority: rand(0..2),
    status: rand(0..2)
  )
end

50.times do |n|
  normal_user.tasks.create(
    title: "Normal_task#{rand(100)}", 
    content:"task_content#{n}",
    deadline_on: Faker::Date.between(from: Date.today, to: 1.month.from_now),
    priority: rand(0..2),
    status: rand(0..2)
    )
end