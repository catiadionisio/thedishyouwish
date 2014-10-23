class AddNomeToComentarios < ActiveRecord::Migration
  def change
    add_column :comentarios, :nome, :string
  end
end
