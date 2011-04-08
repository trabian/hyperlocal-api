class MembersController < ApplicationController

  inherit_resources

  actions :index, :show, :update

  respond_to :json

end
