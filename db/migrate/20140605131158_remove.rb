class Remove < ActiveRecord::Migration
  def change
  	drop_table :ingredientes
  end
end
