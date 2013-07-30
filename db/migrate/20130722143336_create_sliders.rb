class CreateSliders < ActiveRecord::Migration
  def change
    create_table :sliders do |t|
      t.binary :image
      t.binary :background_image
      t.string :header
      t.string :body_tag
      t.integer :account_id, :limit=>8

      t.timestamps
    end
  end
end
