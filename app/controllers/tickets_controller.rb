class TicketsController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources
  
  belongs_to :user, :optional => true
  belongs_to :group, :optional => true
  belongs_to :member, :optional => true

  actions :index, :show, :update

  respond_to :json
  
end
