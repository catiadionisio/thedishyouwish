class AddPessoasToReceitas < ActiveRecord::Migration
  def change
    add_column :receitas, :pessoas, :integer
  end
end
