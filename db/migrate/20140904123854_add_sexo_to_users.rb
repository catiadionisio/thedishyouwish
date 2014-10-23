class AddSexoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sexo, :string
  end
end
