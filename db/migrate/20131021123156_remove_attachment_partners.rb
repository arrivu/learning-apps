class RemoveAttachmentPartners < ActiveRecord::Migration
  def change
    remove_attachment :users, :partner
  end
end
