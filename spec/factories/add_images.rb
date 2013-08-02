# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :add_image do
    image ""
    image_type "MyString"
    file_name "MyString"
    account_id 1
  end
end
