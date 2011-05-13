class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :member_id

  belongs_to :member
  has_many :tickets, :foreign_key => 'assigned_user_id'

  def as_json(options={})
    options.merge!(self.class.json_options)
    super options
  end

  def name
    [self.first_name, self.last_name].compact.join ' '
  end

  def self.json_options
    {
      :only => [
        :email,
        :id,
        :first_name,
        :last_name
      ],
      :methods => [
        :name
      ]
    }
  end

end
