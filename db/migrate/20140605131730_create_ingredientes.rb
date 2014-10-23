class CreateIngredientes < ActiveRecord::Migration
  def change
    create_table :ingredientes do |t|
      t.string :nome
      t.integer :seccao_id
      t.float :peso_medio

      t.timestamps
    end
  end
end
