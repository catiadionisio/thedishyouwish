class CreateReceitaTiporefeicaos < ActiveRecord::Migration
  def change
    create_table :receita_tiporefeicaos do |t|
      t.integer :receita_id
      t.integer :tiporefeicao_id

      t.timestamps
    end
  end
end
