class Partner < ActiveRecord::Base
  attr_accessible :company_name, :image,:uploaded_file,:file_name,:account_id,:comments
  belongs_to :account
  def uploaded_file=(incoming_file)
        self.file_name = incoming_file.original_filename
        self.image_type = incoming_file.content_type
        self.image = incoming_file.read
  end

end
