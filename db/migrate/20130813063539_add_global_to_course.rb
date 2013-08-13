class AddGlobalToCourse < ActiveRecord::Migration
  def change
  add_column :courses, :global, :boolean
  end
end
