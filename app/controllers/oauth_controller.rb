class OauthController < ApplicationController

  def authorize
    if current_user
      render 'oauth/authorize'
    else
      redirect_to new_user_session_path
    end
  end

  def grant
    head oauth.grant!(current_user.id)
  end

  def deny
    head oauth.deny!
  end

end
