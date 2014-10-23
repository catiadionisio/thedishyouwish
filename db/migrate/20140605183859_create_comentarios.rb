class CreateComentarios < ActiveRecord::Migration
  def change
    create_table :comentarios do |t|
      t.date :data
      t.integer :user_id
      t.text :conteudo
      t.integer :receita_id

      t.timestamps
    end
  end
end
