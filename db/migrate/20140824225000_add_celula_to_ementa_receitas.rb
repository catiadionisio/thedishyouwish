class AddCelulaToEmentaReceitas < ActiveRecord::Migration
  def change
    add_column :ementa_receitas, :celula, :string
  end
end
