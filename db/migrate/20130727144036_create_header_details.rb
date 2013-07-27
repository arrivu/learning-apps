class CreateHeaderDetails < ActiveRecord::Migration
  def change
    create_table :header_details do |t|
      t.binary :logo
      t.binary :theme
      t.string :logo_name
      t.string :logo_type
      t.string :theme_name
      t.string :theme_type
      t.string :message
      t.string :account_id

      t.timestamps
    end
  end
end
