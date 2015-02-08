class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :ensure_user

  def strava
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    # @user.update_attribute :strava_token, params[:code]
    if @user.persisted?      
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Strava") if is_navigational_format?
    else
      session["devise.strava_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end