class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user_auth('GitHub')
  end

  def vkontakte
    user_auth('VK')
  end

  private

  def user_auth(proveder_name)
    auth = request.env['omniauth.auth']
    if auth[:info][:email].nil?
      @authorization = Authorization.find_by(provider: auth[:provider], uid: auth[:uid])

      if !@authorization || !@authorization.confirmed?
        @authorization = Authorization.new(provider: auth[:provider], uid: auth[:uid])
        render 'authorizations/email_request'
        return
      end

      @user = @authorization.user
    end

    @user ||= User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: proveder_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end