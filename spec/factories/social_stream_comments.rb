# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :social_stream_comment do
    twitter_comment_script "MyString"
    facebook_comment_script "MyString"
    account_id "MyString"
  end
end
