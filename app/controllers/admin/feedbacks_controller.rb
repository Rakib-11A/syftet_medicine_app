module Admin
  class FeedbacksController < BaseController
    before_action :set_feedback , only: [:show, :checked_feedback, :update, :destroy]
    def index
      @feedbacks = Feedback.all.order(created_at: :desc).page(params[:page]).per(20)
    end

    def show

    end

    def checked_feedback
      @feedback.check_feedback(current_user)
      redirect_to admin_feedbacks_path
    end

    private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end
  end
end
