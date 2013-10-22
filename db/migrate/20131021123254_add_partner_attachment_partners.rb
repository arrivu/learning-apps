class AddPartnerAttachmentPartners < ActiveRecord::Migration
 
  def change
    add_attachment :partners, :partner
  end

end
