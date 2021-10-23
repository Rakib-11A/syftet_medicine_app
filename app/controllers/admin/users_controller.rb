module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :orders, :addresses ]

    def index
      @users = admin_collection
      @users = @users.page(params[:page]).per(20)
      respond_to do |format|
        format.html
        format.json { render :json => json_data }
      end
    end

    def customer
      @users = customer_collection.page(params[:page]).per(20)
      respond_to do |format|
        format.html
        format.json { render :json => json_data }
      end
    end

    def supplier
      @users = supplier_collection
      respond_to do |format|
        format.html
        format.json { render :json => json_data }
      end
    end

    def new
      @user = User.new({role: params[:role]})
    end

    def edit
    end

    def show
      redirect_to edit_admin_user_path(@user)
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash.now[:success] = 'User has been successfully created'
        render :edit
      else
        render :new
      end
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update_attributes(user_params)
        flash.now[:success] = t(:account_updated)
      end

      render :edit
    end

    def login
      user = User.find_by_id(params[:id])
      current_user = user
      current_user.reload
      sign_in :user, current_user
      current_user.reload
      redirect_to root_path
    end

    def addresses
      if request.put?
        if @user.update_attributes(user_params)
          flash.now[:success] = t(:account_updated)
        end
        render :addresses
      end

    end

    def orders
       @orders = @user.orders
    end

    private

    def user_params
      params.require(:user).permit(:name,:email , :password, :password_confirmation, :role, :company, :initial_balance, :initial_balance_date, :mobile, :landphone)
    end

    def set_user
      @user = User.find_by_id(params[:id])
    end

    # handling raise from Admin::ResourceController#destroy
    def user_destroy_with_orders_error
      invoke_callbacks(:destroy, :fails)
      render status: :forbidden, text: Spree.t(:error_user_destroy_with_orders)
    end

    def sign_in_if_change_own_password
      if current_user == @user && @user.password.present?
        sign_in(@user, event: :authentication, bypass: true)
      end
    end

    def admin_collection
      collection User.admins
    end

    def customer_collection
      collection User.customers
    end

    def supplier_collection
      collection User.suppliers
    end

    def collection(users)
      @search = User.new
      if params[:quick_search].present?
        query = params[:quick_search].downcase
        users.where("lower(name) like '%#{query}%' or lower(email) like '%#{query}%'")
      elsif params[:user].present?
        @search = User.new(user_params)
        users = users.where("lower(name) like '%#{params[:user][:name].downcase}%'") unless params[:user][:name].blank?
        users = users.where("lower(email) like '%#{params[:user][:email].downcase}%'") unless params[:user][:email].blank?
        users
      else
        users
      end
    end
  end
end
