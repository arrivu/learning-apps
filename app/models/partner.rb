class Partner < ActiveRecord::Base
  attr_accessible :company_name,:partner,:account_id,:comments
  belongs_to :account
  has_attached_file :partner, :styles => { :thumb => "180x160#",:small=> "40x40#" },
                    :default_url => "/images/:style/partner.png"
  def uploaded_file=(incoming_file)
        self.file_name = incoming_file.original_filename
        self.image_type = incoming_file.content_type
        self.image = incoming_file.read
  end

end
