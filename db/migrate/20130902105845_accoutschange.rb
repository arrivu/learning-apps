class Accoutschange < ActiveRecord::Migration
  def change
  	remove_column :accounts, :seetingsnew, :text
  end
end
