class AddOrdemToConfeccaos < ActiveRecord::Migration
  def change
    add_column :confeccaos, :ordem, :integer
  end
end
