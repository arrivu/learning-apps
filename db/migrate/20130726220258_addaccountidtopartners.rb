class Addaccountidtopartners < ActiveRecord::Migration
 def change
 	add_column :partners,:account_id,:integer, :limit=>8
 end
end
