class DropTables < ActiveRecord::Migration
  def change
  	drop_table :semanas
  	drop_table :refeicaos
  end
end
