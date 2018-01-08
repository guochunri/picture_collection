class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def require_CustomerManager!
    unless current_user.is_CustomerManager?
      flash[:alert] = t('warning-not-admin')
      redirect_to root_path
    end
  end

  def require_admin!
    unless current_user.is_admin?
      redirect_to "/", alert: t('warning-not-admin')
    end
  end

end
