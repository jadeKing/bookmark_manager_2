feature 'User browsers the list of links' do
  before(:each) do
    Link.create(url: 'http://www.makersacademy.com',
                title: 'Makers Academy')
  end
  scenario 'when opening the homepage' do
    visit '/'
    expect(page).to have_content('Makers Academy')
  end
end
