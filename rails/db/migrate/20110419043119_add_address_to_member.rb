class AddAddressToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :street, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :zip, :string
    add_column :members, :phone, :string
  end

  def self.down
    remove_column :members, :street
    remove_column :members, :city
    remove_column :members, :state
    remove_column :members, :zip
    remove_column :members, :phone
  end
end
