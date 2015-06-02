class LandingController < ApplicationController

  def index
    @user = User.where(id: params[:user_id]).first if current_user.present? && current_user.is_admin?
    @user ||= current_user
  end

end
