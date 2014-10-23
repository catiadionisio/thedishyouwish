class CreateConfeccaos < ActiveRecord::Migration
  def change
    create_table :confeccaos do |t|
      t.integer :receita_id
      t.string :passo

      t.timestamps
    end
  end
end
