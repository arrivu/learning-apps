# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :omniauth_link do
    face_book "MyString"
    linked_in "MyString"
    gmail "MyString"
    account_id "MyString"
  end
end
