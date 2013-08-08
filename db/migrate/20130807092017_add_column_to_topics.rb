class AddColumnToTopics < ActiveRecord::Migration
  def change
  	add_column :topics,:parent_id,:integer, :limit=>8
  	add_column :topics,:root_id,:integer, :limit=>8
  	add_column  :topics, :global, :boolean

  end
end
