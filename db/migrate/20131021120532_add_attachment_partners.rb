class AddAttachmentPartners < ActiveRecord::Migration
  def change
    add_attachment :users, :partner
  end
end
