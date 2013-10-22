class Slider < ActiveRecord::Base
  attr_accessible :account_id,  :body_tag, :header, :data,:background_image,:content_image
  belongs_to :slider
  validates :body_tag, length: { maximum: 500}
  has_attached_file :content_image, :styles => { :thumb => "300x280#",:small=> "140x140#" },
                    :default_url => "/images/:style/content_image.png"
  has_attached_file :background_image, :styles => { :thumb => "1800x360#",:small=> "340x140#" },
                    :default_url => "/images/:style/background_image.png"                 


  # def image=(new_filename)
  #   write_attribute("image", sanitize_filename(new_filename))
  # end  
end
