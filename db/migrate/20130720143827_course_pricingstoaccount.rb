class CoursePricingstoaccount < ActiveRecord::Migration
 
  def change
  	add_column :course_pricings, :account_id, :integer, :limit=>8
  end
end
