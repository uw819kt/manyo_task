# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Task.create(
  title: "first_task", 
  content:"task_content1",
  deadline_on: Date.new(2022, 2, 18),
  priority: 1,
  status: 0
  )

Task.create(
  title: "second_task", 
  content:"task_content2",
  deadline_on: Date.new(2022, 2, 17),
  priority: 2,
  status: 1
  )

Task.create(
  title: "third_task", 
  content:"task_content3",
  deadline_on: Date.new(2022, 2, 16),
  priority: 0,
  status: 2
  )

10.times do |n|
  Task.create(
    title: "#{i.ordinalize}_Title", 
    content:"task_content#{n}",
    deadline_on: Faker::Date.between(from: Date.today, to: 1.month.from_now)
    priority: rand(0..2),
    status: rand(0..2)
    )
end