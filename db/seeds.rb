require 'open-uri'
require 'net/http'

def generate_random_image
  # Fetch random image URL from Unsplash API
  access_key = 'ttmgSgDGmNG6ih6kMmWjeIwdu2jrsEuBdrUxg_E-uZo'
  url = URI.parse("https://api.unsplash.com/photos/random?client_id=#{access_key}")
  response = Net::HTTP.get_response(url)
  json = JSON.parse(response.body)
  image_url = json['urls']['regular']

end
def generate_random_album
  access_key = 'y2DOCsMbq4sVkOmC2UC9U4270AIRy2YBTx7vLssYkLQ'
  url = URI.parse("https://api.unsplash.com/photos/random?client_id=#{access_key}")
  response = Net::HTTP.get_response(url)
  json = JSON.parse(response.body)
  image_url = json['urls']['regular']

end
# ======================User======================
User.create(first_name: "Admin", last_name: "Admin", email: "admin@admin.com", role: 0,password: 123456,phone_number: "0987654321",birthday: DateTime.now, address: "48 Thiên Hộ Dương")
User.create(first_name: "User", last_name: "User", email: "user@user.com", role: 1,password: 123456,phone_number: "0987654321",birthday: DateTime.now, address: "48 Thiên Hộ Dương")
# # User.create(first_name: "Ta", last_name: "Anh", email: "quocanh10a2@gmail.com", role: 0,password: 123456)
#
10.times do |n|
  first_name  = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "user_#{n+1}@railstutorial.org"
  password = "123456"
  User.create!(first_name:  first_name,
               last_name: last_name,
               email: email,
               password: password,
               phone_number: "0987654321",
               birthday: DateTime.now,
               address: "48 Thiên Hộ Dương"
  )
end
#
50.times do
  user_id = User.pluck(:id).sample
  photo = Photo.new(
    description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
    title: Faker::Lorem.sentence(word_count: [7,8,9,10,11].sample),
    user_id: user_id,
    is_public: [true,false].sample
  )

  file = URI.open(generate_random_image)
  photo.img.attach(io: file, filename: "file_name")
  photo.save

end

50.times do
  user_id = User.pluck(:id).sample
  post = Post.new(
    title: Faker::Lorem.sentence(word_count:  [7,8,9,10,11].sample),
    description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
    user_id: user_id,
    published: true,
    published_at: rand(2.years).seconds.from_now,
    tag_list: ["docker,java","java","c#,boostrap","ruby,boostrap","flask,python",
               "rubyonrails","boostrap","javaspring",
               "entityframework,c#","flask","vuejs,boostrap,javascript","reactjs,javascript", "javascript"].sample
  )

  file = URI.open(generate_random_album)
  post.header_image.attach(io: file, filename: "file_name")
  post.save
  element = post.elements.new(
    element_type: "paragraph",
    content: Faker::Lorem.sentence(word_count: 100, supplemental: true, random_words_to_add:2)
  )
  element.save
end