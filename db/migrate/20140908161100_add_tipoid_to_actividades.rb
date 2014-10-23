class AddTipoidToActividades < ActiveRecord::Migration
  def change
    add_column :actividades, :tipoid, :integer
  end
end
