class AddImageSlider < ActiveRecord::Migration
   
   def change
    add_attachment :sliders, :content_image
    add_attachment :sliders, :background_image
   end

end
