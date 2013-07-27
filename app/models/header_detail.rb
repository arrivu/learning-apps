class HeaderDetail < ActiveRecord::Base
  attr_accessible :account_id, :logo, :logo_name, :logo_type, :message, :theme, :theme_name, :theme_type, :uploaded_file, :uploaded
 
    def uploaded_file=(incoming_file)
        self.logo_name = incoming_file.original_filename
        self.logo_type = incoming_file.content_type
        self.logo = incoming_file.read
    end
    def uploaded=(incoming_file)
        self.theme_name = incoming_file.original_filename
        self.theme_type = incoming_file.content_type
        self.theme = incoming_file.read
    end


 end