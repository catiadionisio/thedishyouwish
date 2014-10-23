class ChangeTipoFormatInActividade < ActiveRecord::Migration
  def up
    change_column :actividades, :tipo, :string
  end

  def down
    change_column :actividades, :tipo, :string
  end
end
