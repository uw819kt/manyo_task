FactoryBot.define do
  factory :user do
    name { "abc" }
    email { "abc@example.com" }
    password { "password" }
    admin { false }
  end

  factory :second_user, class: User do
    name { "def" }
    email { "def@example.com" }
    password { "password" }
    admin { true } 
  end
  factory :third_user, class: User do
    name { "ghi" }
    email { "ghi@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false } 
  end
end
