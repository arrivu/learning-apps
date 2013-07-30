class CreateAccountSettings < ActiveRecord::Migration
  def change
    create_table :account_settings do |t|
      t.boolean :knowledge_partners
      t.boolean :media_partners
      t.boolean :slide_show
      t.boolean :popular_speak
      t.boolean :testimonial
      t.integer :account_id, :limit=>8

      t.timestamps
    end
  end
end
