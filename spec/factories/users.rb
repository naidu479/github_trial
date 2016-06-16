FactoryGirl.define do

  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:username) { |n| "user#{n}" }
  factory :user do
    email
    username
    password '12345678'
    password_confirmation '12345678'
    #roles :admin
  end

  #roles
factory :admin, class: User do
                    email
                    username
                    password '12345678'
                    password_confirmation '12345678'
                    roles :admin
                  end
end
