class Ticket < ActiveRecord::Base
  
  has_many :comments
  belongs_to :member
  belongs_to :assigned_user, :class_name => "User"

  def tags
    return [] if tags_raw.nil?
    tags_raw.split(" ")
  end
  
  def tags=(tags_array)
    tags_raw = tags_array.join(" ")
  end
  
  def type
    ticket_type
  end

end
