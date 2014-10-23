class Restricao < ActiveRecord::Base
	belongs_to :user
	belongs_to :ingrediente
end
