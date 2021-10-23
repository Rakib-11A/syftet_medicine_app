class Api::ApiBase < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :load_order

  def load_user
    @user = User.find_by_tokens(http_auth_header)
    if @user.present?
      bypass_sign_in(@user)
      warden.set_user @user
      @current_user = @user
    else
      render json: {success: false, error: 'Unauthorized request'}, status: 401
    end
  end

  def current_order(create_order = false)
    if create_order && @order.blank?
      order = Order.new
      order.guest_token = get_token
      order.user_id = current_user.id if current_user.present?
      order.state = 'address'
      order.store = StockLocation.active_stock_location
      order.save!
      @order = order
    end
    unless @order.present? && @order.completed?
      @order
    end
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      ''
    end
  end

  def get_token
    token = request.headers['GuestToken'].to_s
    unless token.present?
      token = SecureRandom.urlsafe_base64(nil, false)
      cookies[:guest_token] = {
          :value => token,
          :expires => 1.year.from_now
      }
    end
    token
  end

  def load_order
    @order ||= Order.get_incomplete_order(get_token, current_user)
  end
end
