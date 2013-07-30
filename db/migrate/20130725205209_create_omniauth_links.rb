class CreateOmniauthLinks < ActiveRecord::Migration
  def change
    create_table :omniauth_links do |t|
      t.string :face_book
      t.string :linked_in
      t.string :gmail
      t.integer :account_id, :limit=>8

      t.timestamps
    end
  end
end
