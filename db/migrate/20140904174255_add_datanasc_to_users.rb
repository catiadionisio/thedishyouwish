class AddDatanascToUsers < ActiveRecord::Migration
  def change
    add_column :users, :datanasc, :date
  end
end
