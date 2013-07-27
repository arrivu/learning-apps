class Addaccountidtopartners < ActiveRecord::Migration
 def change
 	add_column :partners,:account_id,:string
 end
end
