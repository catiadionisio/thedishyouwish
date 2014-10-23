class CreateReceitaIngredientes < ActiveRecord::Migration
  def change
    create_table :receita_ingredientes do |t|
      t.integer :receita_id
      t.integer :ingrediente_id
      t.float :quantidade
      t.integer :medida_id

      t.timestamps
    end
  end
end
