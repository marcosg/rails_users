FactoryGirl.define do
  factory :user do
    name     "Someone Happy"
    email    "Someone@example.com"
    password "password"
    password_confirmation "password"
  end
end