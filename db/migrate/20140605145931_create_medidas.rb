class CreateMedidas < ActiveRecord::Migration
  def change
    create_table :medidas do |t|
      t.string :nome
      t.float :ml
      t.float :gr

      t.timestamps
    end
  end
end
