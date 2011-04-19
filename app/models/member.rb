class Member < ActiveRecord::Base

  has_one :user
  has_many :tickets
  
  def as_json(options={})
    options.merge!(Member.json_options)
    super options
  end
  
  def self.json_options
    {
      :except => [
        :created_at,
        :updated_at,
        :id
      ],
      :methods => [
        :first_name,
        :last_name
      ]
    }
  end

end
