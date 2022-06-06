class AuthorizationsMailer < ApplicationMailer

  def email_confirmation(authorization)
    @auth = authorization
    mail to: @auth.user.email, subject: 'Confirm your registration in QNA'
  end

end