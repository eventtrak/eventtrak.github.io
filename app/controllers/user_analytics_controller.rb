class UserAnalyticsController < ApplicationController
  def create
    UserAnalytics.create(get_params)
    render json: { success: 1 }
  end

  def get_params
    params.require(:analytic).permit(:action, :is_registered, :target, :url, :user_identifier, :value, :remember_token)
  end
end
