class RemoveColumns < ActiveRecord::Migration
	def self.up
	  remove_column :comentarios, :data
	end
end
