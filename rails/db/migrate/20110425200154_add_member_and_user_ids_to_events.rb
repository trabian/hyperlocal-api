class AddMemberAndUserIdsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :member_id, :integer
    add_column :events, :user_id, :integer
  end

  def self.down
    remove_column :events, :user_id
    remove_column :events, :member_id
  end
end
