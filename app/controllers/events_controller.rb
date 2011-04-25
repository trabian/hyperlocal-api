class EventsController < ApplicationController

  inherit_resources

  respond_to :json

  belongs_to :event, :optional => true

protected

  def collection
    @events ||= association_chain.blank? ? Event.roots.descending : association_chain[-1].children.ascending
  end

end
