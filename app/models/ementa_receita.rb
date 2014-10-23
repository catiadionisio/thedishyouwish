class EmentaReceita < ActiveRecord::Base
	belongs_to :ementa
	belongs_to :receita
	belongs_to :refeicao
	belongs_to :tiporefeicao
	belongs_to :semana
end
