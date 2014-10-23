class RemoveColummn < ActiveRecord::Migration
  	def self.up
	  remove_column :receitas, :tiporefeicao_id
	end
end
