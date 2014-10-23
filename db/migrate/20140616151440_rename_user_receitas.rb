class RenameUserReceitas < ActiveRecord::Migration
  def change
  	rename_table :user_receita, :user_receitas
  end
end
