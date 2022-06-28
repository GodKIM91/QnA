class DailyDigestMailer < ApplicationMailer

  def digest(user, content)
    @greeting = user.email.split('@').first
    @questions = content

    mail to: user.email
  end
end
