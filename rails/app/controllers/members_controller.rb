class MembersController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources

  actions :index, :show, :update

  respond_to :json

end
