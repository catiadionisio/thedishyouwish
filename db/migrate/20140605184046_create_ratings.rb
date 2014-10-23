class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :receita_id
      t.integer :classificacao

      t.timestamps
    end
  end
end
