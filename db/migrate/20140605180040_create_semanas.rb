class CreateSemanas < ActiveRecord::Migration
  def change
    create_table :semanas do |t|
      t.string :nome

      t.timestamps
    end
  end
end
