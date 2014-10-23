class CreateActividades < ActiveRecord::Migration
  def change
    create_table :actividades do |t|
      t.integer :user_id
      t.string :accao
      t.integer :tipo

      t.timestamps
    end
  end
end
