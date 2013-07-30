class TaxRatestoaccount < ActiveRecord::Migration
 
  def change
  	add_column :tax_rates, :account_id, :integer, :limit=>8
  end
end
