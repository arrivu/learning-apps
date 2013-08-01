class AddImage < ActiveRecord::Base
  attr_accessible :account_id, :file_name, :image, :image_type,:uploaded_file
  def uploaded_file=(incoming_file)
        self.file_name = incoming_file.original_filename
        self.image_type = incoming_file.content_type
        self.image = incoming_file.read
  end
end
