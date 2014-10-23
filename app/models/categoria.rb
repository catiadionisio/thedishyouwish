class Categoria < ActiveRecord::Base
	has_many :receita_categorias
	has_many :receitas, :through => :receita_categorias

	accepts_nested_attributes_for :receita_categorias, :allow_destroy => true
	accepts_nested_attributes_for :receitas, :allow_destroy => true

	def to_s
		nome
	end
end
