class Medida < ActiveRecord::Base
	has_many :receita_ingredientes

	def to_s
		nome
	end
end
