class Changestoaccounts < ActiveRecord::Migration
  

  
def self.up
  change_column :accounts, :settings, :string
  change_column_default(:accounts, :settings, :string)
end
  end