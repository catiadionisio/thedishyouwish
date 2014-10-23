class ReceitaTiporefeicao < ActiveRecord::Base
	belongs_to :receita
	belongs_to :tiporefeicao
end
