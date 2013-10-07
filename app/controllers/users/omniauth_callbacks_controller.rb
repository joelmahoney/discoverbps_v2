class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to root_url
    end
  end

	def twitter
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
    	puts "********************** user is persisted"
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
    	puts "********************** user is not persisted"
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to root_url
    end
  end
end