class CreateOmniauthLinks < ActiveRecord::Migration
  def change
    create_table :omniauth_links do |t|
      t.string :face_book
      t.string :linked_in
      t.string :gmail
      t.string :account_id

      t.timestamps
    end
  end
end
