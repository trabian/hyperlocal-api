class CurrentSessionsController < ApplicationController

  before_filter :authenticate_user!, :only => :show

  def show
    render :json => to_json(current_user)
  end

  def create

    user = User.find_by_email(params[:email])
    
    if user.valid_password?(params[:password])
      sign_in('user', user)
      render :json => to_json(user)
    else
      render 403
    end

  end

  def destroy
    sign_out('user')
    render :json => { :message => "Logout successful" }
  end

protected

  def to_json(user)
    user.to_json(:only => [:id, :email], :methods => [:first_name, :last_name], :include => :member)
  end

end
