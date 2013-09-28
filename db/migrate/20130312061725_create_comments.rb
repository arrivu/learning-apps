class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :limit => 50, :default => "" 
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :user
      t.boolean :is_active
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
    add_index :comments, :is_active
  end

  def self.down
    drop_table :comments
  end
end
