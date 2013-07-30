class Footerlinksaddaccountid < ActiveRecord::Migration
  def change
  	add_column :footerlinks, :account_id, :integer, :limit=>8
  	add_column  :footerlinks, :copy_write, :string
  end
end
