feature 'user signs up' do
  scenario 'when being a new user visiting the site' do
    expect { sign_up }.to change(User, :count).by 1
    expect(page).to have_content 'Welcome, alice@example.com'
    expect(User.first.email).to eq 'alice@example.com'
  end

  scenario 'with a password that does not match' do
    expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by 0
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Sorry, your passwords do not match :Þ'
  end

  scenario 'with an email address that already exists' do
    expect { sign_up('a@a.com', 'pass', 'pass') }.to change(User, :count).by 1
    expect { sign_up('a@a.com', 'pass2', 'pass2') }.to change(User, :count).by 0
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Sorry, your email address is already taken :Þ'
  end

  def sign_up(email = 'alice@example.com',
              password = 'oranges!',
              password_confirmation = 'oranges!')
    visit '/users/new'
    expect(page.status_code).to eq 200
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end
end
