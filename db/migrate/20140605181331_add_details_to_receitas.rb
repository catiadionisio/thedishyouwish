class AddDetailsToReceitas < ActiveRecord::Migration
  def change
    add_column :receita, :tiporefeicao_id, :integer
  end
end
