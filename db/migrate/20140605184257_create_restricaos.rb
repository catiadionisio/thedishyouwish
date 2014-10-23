class CreateRestricaos < ActiveRecord::Migration
  def change
    create_table :restricaos do |t|
      t.integer :user_id
      t.integer :ingrediente_id

      t.timestamps
    end
  end
end
