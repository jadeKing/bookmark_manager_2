require_relative 'helpers/session'
feature 'user signs out' do
  include SessionHelpers
  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'While being signed in' do
    sign_in('test@test.com', 'test')
    click_button 'Sign out'
    expect(page).to have_content 'Good bye!'
    expect(page).not_to have_content 'Welcome, test@test.com'
  end
end
