class CreateUserReceita < ActiveRecord::Migration
  def change
    create_table :user_receita do |t|
      t.integer :receita_id
      t.integer :user_id

      t.timestamps
    end
  end
end
