# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

place = Place.create(
  name: "Test name",
  address: "Test address",
  description: "Test description",
  category: "Test category",
  url: "https://example.com",
  opening_hours: "10am - 5pm"
)

post = Post.new(
  user_id: 1,
  place_id: place.id,
  place_rating: 5
)
post.reels.attach(io: File.open('app/assets/videos/testreel.mp4'), filename: 'testreel.mp4', content_type: 'video/mp4')
post.save
