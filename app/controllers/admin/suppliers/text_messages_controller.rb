module Admin
  module Suppliers
    class TextMessagesController < BaseController
      before_action :set_admin_suppliers_text_message, only: [:show, :edit, :update, :destroy]

      # GET /admin/suppliers/text_messages
      # GET /admin/suppliers/text_messages.json
      def index
        @admin_suppliers_text_messages = Admin::Suppliers::TextMessage.all
      end

      # GET /admin/suppliers/text_messages/1
      # GET /admin/suppliers/text_messages/1.json
      def show
      end

      # GET /admin/suppliers/text_messages/new
      def new
        @admin_suppliers_text_message = Admin::Suppliers::TextMessage.new
      end

      # GET /admin/suppliers/text_messages/1/edit
      def edit
      end

      # POST /admin/suppliers/text_messages
      # POST /admin/suppliers/text_messages.json
      def create
        @admin_suppliers_text_message = Admin::Suppliers::TextMessage.new(admin_suppliers_text_message_params)

        respond_to do |format|
          if @admin_suppliers_text_message.save
            format.html { redirect_to @admin_suppliers_text_message, notice: 'Text message was successfully created.' }
            format.json { render :show, status: :created, location: @admin_suppliers_text_message }
          else
            format.html { render :new }
            format.json { render json: @admin_suppliers_text_message.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /admin/suppliers/text_messages/1
      # PATCH/PUT /admin/suppliers/text_messages/1.json
      def update
        respond_to do |format|
          if @admin_suppliers_text_message.update(admin_suppliers_text_message_params)
            format.html { redirect_to @admin_suppliers_text_message, notice: 'Text message was successfully updated.' }
            format.json { render :show, status: :ok, location: @admin_suppliers_text_message }
          else
            format.html { render :edit }
            format.json { render json: @admin_suppliers_text_message.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /admin/suppliers/text_messages/1
      # DELETE /admin/suppliers/text_messages/1.json
      def destroy
        @admin_suppliers_text_message.destroy
        respond_to do |format|
          format.html { redirect_to admin_suppliers_text_messages_url, notice: 'Text message was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin_suppliers_text_message
        @admin_suppliers_text_message = Admin::Suppliers::TextMessage.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def admin_suppliers_text_message_params
        params.require(:admin_suppliers_text_message).permit(:supplier_id, :employee_id, :content, :direction, :read)
      end
    end
  end
end

