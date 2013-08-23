# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_contact_detail do
    address "MyString"
    email_id "MyString"
    account_id 1
  end
end
