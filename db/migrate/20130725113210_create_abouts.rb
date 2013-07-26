class CreateAbouts < ActiveRecord::Migration
  def change
    create_table :abouts do |t|
      t.string :title
      t.string :desc
      t.string :account_id

      t.timestamps
    end
  end
end
