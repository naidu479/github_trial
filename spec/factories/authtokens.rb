FactoryGirl.define do
  factory :authtoken do
    token "MyString"
    last_used_at "2016-06-16 07:12:32"
    sign_in_ip ""
    user_agent "MyString"
    device_id "MyString"
    user nil
  end
end
