# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::ApiBase
      before_action :load_user

      def my_account
        render json: { success: true, account_data: account_data }
      end

      private

      def account_data
        {
          user: { email: @user.email, total_rewards: @user.total_rewards, available_rewards: @user.available_rewards },
          orders: @user.orders.collect do |order|
            { number: order.number, id: order.id, status: order.state, amount: order.net_total, date: order.created_at }
          end
        }
      end
    end
  end
end
