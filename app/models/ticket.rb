class Ticket < ActiveRecord::Base

  belongs_to :assigned_user, :class_name => 'User'

  def as_json(options={})
    options.merge!(self.class.json_options)
    super options
  end

  def self.json_options
    {
      :include => {
        :assigned_user => User.json_options 
      }
    }
  end

end
