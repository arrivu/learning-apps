class RemoveImagePartners < ActiveRecord::Migration

  def change
    remove_column :partners,:image
    remove_column :partners,:file_name
  end

end
