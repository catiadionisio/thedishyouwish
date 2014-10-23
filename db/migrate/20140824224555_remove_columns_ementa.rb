class RemoveColumnsEmenta < ActiveRecord::Migration
	def self.up
	  remove_column :ementa_receitas, :refeicao_id
	  remove_column :ementa_receitas, :tiporefeicao_id
	  remove_column :ementa_receitas, :semana_id
	end
	def self.down
	  add_column :ementa_receitas, :celula, :string
	end
end
