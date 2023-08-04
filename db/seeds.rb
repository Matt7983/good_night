# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
followee = User.create!(name: Faker::Name.name)
follower1 = User.create!(name: Faker::Name.name)
follower2 = User.create!(name: Faker::Name.name)
Follower.create!(followee_id: followee.id, follower_id: follower1.id)
Follower.create!(followee_id: followee.id, follower_id: follower2.id)
Clock.create!(user_id: follower1.id, clock_in: 8.days.before, clock_out: 7.days.before, duration: 1.day)
Clock.create!(user_id: follower1.id, clock_in: 6.days.before, clock_out: 4.days.before, duration: 2.days)
Clock.create!(user_id: follower1.id, clock_in: 10.hours.before, clock_out: 8.hours.before, duration: 2.hours)
Clock.create!(user_id: follower2.id, clock_in: 4.days.before, clock_out: 3.days.before, duration: 1.day)
Clock.create!(user_id: follower2.id, clock_in: 48.hours.before, clock_out: 12.hours.before, duration: 36.hours)
