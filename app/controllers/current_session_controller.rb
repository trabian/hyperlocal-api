class CurrentSessionController < ApplicationController

  before_filter :authenticate_user!

  def show
    render :json => current_user.to_json(:only => [:email], :methods => [:first_name, :last_name])
  end

end
