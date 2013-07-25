class Addaccountidtoinvoice < ActiveRecord::Migration
  def change
  	add_column :invoices,:account_id,:string
  end
end
