class TicketsController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources
  
  belongs_to :user, :optional => true
  belongs_to :group, :optional => true
  belongs_to :member, :optional => true

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
      :except => [
        :tags_raw,
        :assigned_user_id,
        :member_id
      ],
      :include => {
        :comments => {
        },
        :assigned_user => {
          :only => [
            :id
          ],
          :methods => [
            :first_name,
            :last_name
          ]
        },
        :member => {
          :only => [
            :id,
            :first_name,
            :last_name,
            :middle_name
          ]
        }
      },
      :methods => [
        :tags,
        :type
      ]
    }
  end

end
