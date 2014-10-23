class Seccao < ActiveRecord::Base
	has_many :ingredientes
	accepts_nested_attributes_for :ingredientes

	def to_s
		nome
	end
end
