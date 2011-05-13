class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user

  scope :ascending, :order => 'created_at'
  scope :descending, :order => 'created_at DESC'

  def as_json(options={})
    options.merge!(Comment.json_options)
    super(options)
  end

  def self.json_options
    {
      :except => [
        :updated_at,
        :ticket_id,
        :user_id
      ],
      :include => {
        :user => User.json_options
      }
    }
  end
  
end
