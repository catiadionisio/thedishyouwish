class ReceitaIngrediente < ActiveRecord::Base
	belongs_to :receita
	belongs_to :ingrediente
	belongs_to :medida
end
