class CreatePrivacypolicies < ActiveRecord::Migration
  def change
    create_table :privacypolicies do |t|
      t.string :title
      t.text :desc
      t.integer :account_id, :limit=>8

      t.timestamps
    end
  end
end
