FactoryBot.define do
  factory :user do
    name { "ユーザーA" }
    email { "a@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
end
