class AddColumnToTopics < ActiveRecord::Migration
  def change
  	add_column :topics,:parent_topic_id,:integer, :limit=>8
  	add_column :topics,:root_topic_id,:integer, :limit=>8
  	add_column  :topics, :is_global, :boolean

  end
end
