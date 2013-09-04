class RenameTermToTermsAndCondition < ActiveRecord::Migration
  def change
    rename_table :terms, :terms_and_conditions
  end
end
