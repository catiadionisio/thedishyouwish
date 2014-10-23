class RenameEmentaReceita < ActiveRecord::Migration
  def change
  	rename_table :ementa_receita, :ementa_receitas
  end
end
