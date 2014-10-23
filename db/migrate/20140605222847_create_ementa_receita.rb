class CreateEmentaReceita < ActiveRecord::Migration
  def change
    create_table :ementa_receita do |t|
      t.integer :ementa_id
      t.integer :receita_id
      t.integer :refeicao_id
      t.integer :tiporefeicao_id
      t.integer :semana_id
      t.integer :npessoas

      t.timestamps
    end
  end
end
