class ApplicationController < ActionController::Base
  before_action :gon_params

  def gon_params
    gon.params = params.permit(:id)
    gon.user = current_user&.id
  end
end
