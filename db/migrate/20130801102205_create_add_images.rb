class CreateAddImages < ActiveRecord::Migration
  def change
    create_table :add_images do |t|
      t.binary :image
      t.string :image_type
      t.string :file_name
      t.integer :account_id, :limit => 8

      t.timestamps
    end
  end
end
