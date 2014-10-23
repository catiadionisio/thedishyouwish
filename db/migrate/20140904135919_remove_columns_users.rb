class RemoveColumnsUsers < ActiveRecord::Migration
  def self.up
	  remove_column :users, :datanasc
  end
end
