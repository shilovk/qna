# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      respond_to do |format|
        format.html { redirect_back fallback_location: request.fullpath, alert: exception.message }
        format.js { render params[:action], status: :unauthorized }
        format.json { render json: {}, status: :unauthorized }
      end
    else
      session[:next] = request.fullpath
      redirect_to new_user_session_path, alert: 'You have to log in to continue.'
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
