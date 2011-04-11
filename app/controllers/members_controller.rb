class MembersController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources

  actions :index, :show, :update

  respond_to :json
  
  def index
    super do |format|
      format.json do
        render :json => collection.to_json(json_api_options)
      end
    end
  end

  def show
    super do |format|
      format.json do
        render :json => resource.to_json(json_api_options)
      end
    end
  end

protected

  def json_api_options
    {
      :only => [
        :id,
        :first_name,
        :middle_name,
        :last_name
      ]
    }
  end

end
