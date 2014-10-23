class UserReceita < ActiveRecord::Base
	belongs_to :user
	belongs_to :receita
end
