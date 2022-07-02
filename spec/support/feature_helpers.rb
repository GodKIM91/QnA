module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def refresh_indexes
    [Question, Answer, Comment, User].each do |model|
      model.__elasticsearch__.delete_index!
      model.__elasticsearch__.create_index!
      model.__elasticsearch__.import
      model.__elasticsearch__.refresh_index!
    end
  end
end