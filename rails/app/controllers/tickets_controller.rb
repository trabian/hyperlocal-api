class TicketsController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources

  belongs_to :user, :group, :member, :polymorphic => true, :optional => true

  respond_to :json

  def complete

    resource.complete!

    log_state_change(resource)

    respond_with resource

  end

  def reopen

    resource.reopen!

    log_state_change(resource)

    respond_with resource

  end

  protected

    def log_state_change(ticket)
      Event.create(
        :event_type => 'tickets:change_state',
        :actor => current_user,
        :member => ticket.member
      )
    end

end
