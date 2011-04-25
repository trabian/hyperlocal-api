class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :title
      t.string :state
      t.integer :assigned_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
