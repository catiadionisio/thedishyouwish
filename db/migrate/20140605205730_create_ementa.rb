class CreateEmenta < ActiveRecord::Migration
  def change
    create_table :ementa do |t|
      t.integer :user_id
      t.date :data
      t.integer :npessoas

      t.timestamps
    end
  end
end
