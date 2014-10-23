class Ingrediente < ActiveRecord::Base
	belongs_to :seccao

	has_many :receita_ingredientes
	has_many :receitas, :through => :receita_ingredientes

	accepts_nested_attributes_for :receita_ingredientes, :allow_destroy => true
	accepts_nested_attributes_for :receitas, :allow_destroy => true

	has_many :restricaos
  	has_many :users, :through => :restricaos

  	def to_s
		nome
	end

end
