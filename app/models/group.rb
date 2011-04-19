class Group < ActiveRecord::Base

  has_many :users
  has_many :tickets
  
  def as_json(options={})
    options.merge!(Group.json_options)
    super options   
  end
  
  def self.json_options
    {}
  end
  
end
