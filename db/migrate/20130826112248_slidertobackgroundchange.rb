class Slidertobackgroundchange < ActiveRecord::Migration
  
  def change
     add_column :sliders, :background_image_name, :string 
  end
end
