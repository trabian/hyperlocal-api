class ChangeMiddleInitialToMiddleName < ActiveRecord::Migration
  def self.up
    rename_column :members, :middle_initial, :middle_name
  end

  def self.down
    rename_column :members, :middle_name, :middle_initial
  end
end
