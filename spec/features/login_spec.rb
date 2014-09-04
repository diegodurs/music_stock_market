require 'rails_helper'

feature "Login" do
  scenario 'successfull' do
    user = User.create(email: 'user@email.com', password: '1234567')

    visit '/login'
    fill_in 'Password', with: '1234567'
    fill_in 'Email', with: 'user@email.com'
    click 'Login'
  end
end
