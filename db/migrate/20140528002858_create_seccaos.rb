class CreateSeccaos < ActiveRecord::Migration
  def change
    create_table :seccaos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
