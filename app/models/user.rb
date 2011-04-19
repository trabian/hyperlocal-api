class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :member_id

  belongs_to :member
  has_many :tickets, :foreign_key => 'assigned_user_id'

  def first_name
    member.try(:first_name) or super
  end

  def last_name
    member.try(:last_name) or super
  end
  
  def to_json (options={})
    options.merge!(User.json_options)
    super(options)
  end
  
  def self.json_options
    {
      :only => [
        :id,
        :first_name,
        :last_name
      ],
      :methods => [
        :first_name,
        :last_name
      ]
    }
  end

end
