class Changeaccount < ActiveRecord::Migration
  def up
  change_column :accounts, :settings, :text
end
 def down
  change_column :accounts, :settings, :string
 end
end
