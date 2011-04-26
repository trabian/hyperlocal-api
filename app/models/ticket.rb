class Ticket < ActiveRecord::Base

  has_many :comments

  belongs_to :member
  belongs_to :assigned_user, :class_name => "User"
  belongs_to :assigned_group, :class_name => "Group"

  scope :ascending, :order => "created_at"
  scope :descending, :order => "created_at DESC"

  def as_json(options={})
    options.merge!(self.class.json_options)
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
        :tags
      ]
    }
  end

end
