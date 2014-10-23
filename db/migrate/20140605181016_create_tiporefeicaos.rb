class CreateTiporefeicaos < ActiveRecord::Migration
  def change
    create_table :tiporefeicaos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
