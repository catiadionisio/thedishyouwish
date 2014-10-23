class CreateReceita < ActiveRecord::Migration
  def change
    create_table :receita do |t|
      t.string :nome
      t.integer :tempo
      t.integer :dificuldade
      t.text :descricao

      t.timestamps
    end
  end
end
