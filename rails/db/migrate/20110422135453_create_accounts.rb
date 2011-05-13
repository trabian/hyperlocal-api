class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string   "number"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "member_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
