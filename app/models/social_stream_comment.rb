class SocialStreamComment < ActiveRecord::Base
  attr_accessible :account_id, :facebook_comment_script, :twitter_comment_script
end
