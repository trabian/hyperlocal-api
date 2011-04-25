class Member < ActiveRecord::Base

  has_one :user

  has_many :accounts

  def after_create

    Event.create(
      :event_type => 'members:new',
      :actor => self
    )

  end

  def as_json(options={})
    options.merge!(self.class.json_options)
    super options
  end

  def primary_account
    self.accounts.first || {}
  end

  def self.json_options
    {
      :methods => [
        :primary_account
      ]
    }
  end

end
