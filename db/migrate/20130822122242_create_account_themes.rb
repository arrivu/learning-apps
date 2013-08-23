class CreateAccountThemes < ActiveRecord::Migration
  def change
    create_table :account_themes do |t|
      t.string :name
      t.integer :account_id

      t.timestamps
    end
  end
end
