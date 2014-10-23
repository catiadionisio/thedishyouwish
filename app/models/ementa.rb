class Ementa < ActiveRecord::Base
	belongs_to :user
	has_many :ementa_receitas
	has_many :receitas, :through => :ementa_receitas
end
