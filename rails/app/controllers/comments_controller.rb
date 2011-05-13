class CommentsController < ApplicationController

  before_filter :authenticate_user!

  inherit_resources

  belongs_to :ticket

  respond_to :json

  has_scope :ascending, :type => :boolean, :default => true

end
