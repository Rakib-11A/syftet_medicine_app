# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_order
  before_action :load_settings
  helper_method :current_order

  def current_order(create_order = false)
    if create_order && @order.blank?
      order = Order.new
      order.guest_token = get_token
      order.user_id = current_user.id if current_user.present?
      order.admin_id = current_user.id if current_user.present? && current_user.admin?
      order.state = 'address'
      order.store = StockLocation.active_stock_location
      order.save!
      @order = order
    end
    return if @order.present? && @order.completed?

    @order
  end

  # after sign in path override from devise
  def after_sign_in_path_for(resource)
    if resource&.admin?
      admin_path # stored_location_for(resource) || admin_path
    else
      request.env['omniauth.origin'] || stored_location_for(resource || 'user') || root_path
    end
  end

  def get_token
    token = cookies[:guest_token]
    unless token.present?
      token = SecureRandom.urlsafe_base64(nil, false)
      cookies[:guest_token] = {
        value: token,
        expires: 1.year.from_now
      }
    end
    token
  end

  def custom_authenticate_user!
    return if current_user.present?

    session[:user_redirect_to] = request.original_url
    redirect_to "#{root_path}#login"
  end

  def current_currency
    'USD' # Default currency, can be made configurable
  end

  protected

  def load_order
    @load_order ||= Order.get_incomplete_order(get_token, current_user)
  end

  def load_settings
    @settings = Setting.new
  end

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up)
  end
end
