class Member < ActiveRecord::Base

  has_one :user
  has_many :tickets
  has_many :accounts
  has_many :events

  def as_json(options={})
    options.merge!(Member.json_options)
    super options
  end

  def self.json_options
    {
      :except => [
        :created_at,
        :updated_at
      ],
      :methods => [
        :primary_account
      ]
    }
  end

  def after_create

    Event.create(
      :event_type => 'members:new',
      :actor => self,
      :member => self
    )

  end

  def primary_account
    self.accounts.first || {}
  end

end
