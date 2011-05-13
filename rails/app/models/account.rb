require 'hyperlocal'

class Account < ActiveRecord::Base

  belongs_to :member

  def after_create

    Hyperlocal::Timeline.insert(
      :title => "Account created",
      :type => 'account',
      :text => "{{ actor }} created a new {{ subject }}",
      :actor => member.as_json.merge(:type => 'member'),
      :subject => self.as_json.merge(:type => 'account'),
      :tags => [{
        :id => 1,
        :name => 'account'
      }, {
        :id => 2,
        :name => 'new-account'
      }],
      :created_at => Time.now
    )

  end

end
