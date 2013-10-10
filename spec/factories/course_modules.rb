# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_module do
    course_id 1
    course_module "MyString"
    account_id 1
  end
end
