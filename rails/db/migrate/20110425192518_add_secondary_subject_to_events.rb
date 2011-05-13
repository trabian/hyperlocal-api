class AddSecondarySubjectToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :secondary_subject_id, :integer
    add_column :events, :secondary_subject_type, :string
  end

  def self.down
    remove_column :events, :secondary_subject_type
    remove_column :events, :secondary_subject_id
  end
end
