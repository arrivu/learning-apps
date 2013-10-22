class RemoveImageSlider < ActiveRecord::Migration
   def change
    remove_column :sliders,:background_image
    remove_column :sliders,:background_image_type
    remove_column :sliders,:background_image_name
    remove_column :sliders,:image
    remove_column :sliders,:image_name
    remove_column :sliders,:image_type
  end
end
