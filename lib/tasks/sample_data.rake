namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Admin User",
                         email: "admin@railstutorial.org",
                         password: "foobar123",
                         password_confirmation: "foobar123",
                         admin: true)
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar123",
                 password_confirmation: "foobar123")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end

