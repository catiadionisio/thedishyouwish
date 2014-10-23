class AddNotaToReceitaIngredientes < ActiveRecord::Migration
  def change
    add_column :receita_ingredientes, :nota, :string
  end
end
