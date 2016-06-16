FactoryGirl.define do
  factory :identity do
    user nil
    provider "MyString"
    accesstoken "MyString"
    refreshtoken "MyString"
    uid "MyString"
  end
end
