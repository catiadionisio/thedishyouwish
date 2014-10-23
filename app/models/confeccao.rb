class Confeccao < ActiveRecord::Base
	belongs_to :receita

	def to_s
		passo
	end
end
