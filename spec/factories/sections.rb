# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    course_id 1
    section "MyString"
    account_id 1
  end
end
