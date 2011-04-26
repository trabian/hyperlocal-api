class TicketsController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources

  belongs_to :user, :group, :member, :polymorphic => true, :optional => true

  respond_to :json

end
