class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.integer :actor_id
      t.string :actor_type
      t.integer :subject_id
      t.string :subject_type
      t.string :event_type
      t.string :ancestry
      t.timestamps
    end
    add_index :events, :ancestry
  end

  def self.down
    drop_table :events
  end
end
