require_relative '../lib/create_place_helper'
require_relative '../app/services/s3_service'
# reauire URI

def create_users
  User.create(
    email: 'nicholas@nicholashennellfoley.com',
    username: 'Nick',
    password: 'password'
  )
  puts 'Created User Nick'

  puts 'Created All Users'

  User.all
end

def get_videos
  s3_client = Aws::S3::Client.new
  s3_manager = S3Manager.new(s3_client)
  
  m3u8_videos = []
  videos_with_places = []
  place_id_extraction_regex = /- (.+)/

  all_objects = s3_manager.list_objects(ENV['S3_DESTINATION_BUCKET'])

  all_objects.each do |object|
    m3u8_videos << object.key.slice(0, object.key.length - 5) if object.key.end_with?('.m3u8')
  end

  m3u8_videos.each_with_index do |key_string, idx|
    if idx != m3u8_videos.length - 1 && m3u8_videos[idx + 1].include?(key_string)
      videos_with_places << { video_id: key_string + '.m3u8', place_id: key_string.match(place_id_extraction_regex)[1] }
    end
  end

  videos_with_places
end

def create_posts_and_places(videos_with_places, users)
  puts "#{videos_with_places.size} post to do"
  videos_with_places.each_with_index do |video, idx|
    puts "Creating place for post #{idx + 1}"
    place = create_place_helper(video[:place_id])
    post = Post.create(
      user_id: users.sample.id,
      place_id: place.id,
      place_rating: rand(1..5),
      video_url: ENV['CLOUDFRONT_BASE_URL'] + video[:video_id],
      video_public_id: video[:video_id]
    )
    puts "Saved post #{idx + 1} of #{videos_with_places.size} to #{place.name}"
    puts post.persisted?
    puts post.errors.full_messages

  end
end

users = create_users
videos_with_places = get_videos
create_posts_and_places(videos_with_places, users)

puts Post.all