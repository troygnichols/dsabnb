class UserMailerPreview < ActionMailer::Preview
  def registration_confirmation
    UserMailer.registration_confirmation(fake_user)
  end

  def welcome_email
    UserMailer.welcome_email(fake_user)
  end

  private

  def fake_user
    User.new(id: 0, first_name: "Testuser", confirm_token: "fake-confirm-token")
  end
end
