class ApplicationController < ActionController::Base
  before_action :gon_params

  def gon_params
    gon.params = params.permit(:id)
    gon.user = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
