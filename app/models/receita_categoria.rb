class ReceitaCategoria < ActiveRecord::Base
	belongs_to :receita
	belongs_to :categoria

	def self.get_by_categoria (categoria_id)
		ReceitaCategoria.where("categoria_id=?", categoria_id)
	end
end
