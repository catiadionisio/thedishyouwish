class CreateReceitaCategoria < ActiveRecord::Migration
  def change
    create_table :receita_categoria do |t|
      t.integer :receita_id
      t.integer :categoria_id

      t.timestamps
    end
  end
end
