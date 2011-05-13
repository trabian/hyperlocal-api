class Event < ActiveRecord::Base

  belongs_to :actor, :polymorphic => true
  belongs_to :subject, :polymorphic => true
  belongs_to :secondary_subject, :polymorphic => true

  has_ancestry

  scope :descending, :order => "created_at DESC"
  scope :ascending, :order => "created_at"

  def as_json(options={})
    options.merge!(self.class.json_options)
    super options
  end

  def subject_json
    subject.as_json
  end

  def secondary_subject_json
    secondary_subject.as_json
  end

  def actor_json
    actor.as_json
  end

  def events
    self.children
  end

  def self.json_options
    {
      :methods => [
        :subject_json,
        :actor_json,
        :secondary_subject_json
      ]
    }
  end

end
