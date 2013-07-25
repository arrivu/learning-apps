class CreateSocialStreamComments < ActiveRecord::Migration
  def change
    create_table :social_stream_comments do |t|
      t.string :twitter_comment_script
      t.string :facebook_comment_script
      t.string :account_id

      t.timestamps
    end
  end
end
