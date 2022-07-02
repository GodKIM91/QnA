class UsersController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  def show
    @user = User.find(params[:id])
  end
end