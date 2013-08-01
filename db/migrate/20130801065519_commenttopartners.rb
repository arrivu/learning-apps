class Commenttopartners < ActiveRecord::Migration
  def change
   
     add_column :partners, :comments, :string
  end
end
