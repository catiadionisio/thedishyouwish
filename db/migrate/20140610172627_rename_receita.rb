class RenameReceita < ActiveRecord::Migration
  def change
  	rename_table :receita, :receitas
  end
end
