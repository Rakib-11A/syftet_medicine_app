module Admin
  class ContactsController < BaseController
    before_action :set_contact , only: [:show, :checked_query, :update, :destroy]
    def index
      @contacts = Contact.all.order(created_at: :desc).page(params[:page]).per(20)
    end

    def show

    end

    def checked_query
      @contact.checked(current_user)
      redirect_to admin_contacts_path
    end

    def check_order
      p params[:order_id]
      @order = Order.find_by_number(params[:order_number])
      if @order.present?
        redirect_to edit_admin_order_path(@order)
      else
        redirect_to admin_contacts_path, notice: 'Invalid Order Number'
      end

    end


    private
    def set_contact
      @contact = Contact.find(params[:id])
    end
  end
end

