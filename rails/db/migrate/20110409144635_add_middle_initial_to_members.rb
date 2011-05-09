class AddMiddleInitialToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :middle_initial, :string
  end

  def self.down
    remove_column :members, :middle_initial
  end
end
