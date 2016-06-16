FactoryGirl.define do

	sequence(:email) { |n| "user#{n}@example.com" }
	
	factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    #roles :admin
  end

  #roles
factory :admin, class: User do
                    email
                    password '12345678'
                    password_confirmation '12345678'
                    roles :admin
                  end
  
end
