class Tiporefeicao < ActiveRecord::Base
	has_many :receita_tiporefeicaos
	has_many :receitas, :through => :receita_tiporefeicaos

	accepts_nested_attributes_for :receita_tiporefeicaos, :allow_destroy => true
	accepts_nested_attributes_for :receitas, :allow_destroy => true
	
	has_many :ementa_receitas

	def to_s
		nome
	end
end
