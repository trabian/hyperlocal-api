class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :title
      t.string :ticket_type
      t.integer :account_id
      t.integer :member_id
      t.string :state
      t.integer :assigned_user_id
      t.string :tags_raw

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
