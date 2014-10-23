class CreateRefeicaos < ActiveRecord::Migration
  def change
    create_table :refeicaos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
