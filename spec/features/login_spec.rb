require 'rails_helper'

feature "Login" do
  scenario 'successfull' do
    user = User.create(email: 'user@email.com', password: '1234567')

    visit '/login'
    fill_in 'Password', with: '1234567'
    fill_in 'Email', with: 'user@email.com'
    click_button 'Sign in'
  end

  scenario 'failing' do
    user = User.create(email: 'user@email.com', password: '1234567')

    visit '/login'
    fill_in 'Password', with: 'not the good password'
    fill_in 'Email', with: 'user@email.com'
    click_button 'Sign in'

    expect(page).to have_content('Error')
  end
end
