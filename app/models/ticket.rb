class Ticket < ActiveRecord::Base
  
  has_many :comments
  belongs_to :member
  belongs_to :assigned_user, :class_name => "User"
  belongs_to :assigned_group, :class_name => "Group"

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
  
  def as_json(options={})
    options.merge!(Ticket.json_options)
    super options   
  end
  
  def self.json_options
    {
      :except => [
        :tags_raw,
        :assigned_user_id,
        :member_id
      ],
      :include => {
        :comments => Comment.json_options,
        :assigned_user => User.json_options,
        :assigned_group => Group.json_options,
        :member => Member.json_options
      },
      :methods => [
        :tags,
        :type
      ]
    }
  end

end
