class MembersController < ApplicationController

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
        :last_name,
        :middle_initial
      ]
    }
  end

end
