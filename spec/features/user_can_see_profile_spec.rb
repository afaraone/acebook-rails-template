require 'rails_helper'

RSpec.feature 'Profile page', type: :feature do
  before(:each) do
    sign_up_correct_helper
    create_post('Hello!')
  end

  context 'User visits their profile' do
    before do
      visit '/profile'
    end

    scenario 'Their name is displayed' do
      expect(find('#user-name-title')).to have_content('TestName')
    end

    scenario 'They see their own posts' do
      expect(find('#1.post-message')).to have_content 'Hello!'
    end

    scenario 'posts appear in reverse chronological order' do
      Timecop.freeze(Time.zone.parse('13:00 3 October 2018'))
      create_post('First post')
      Timecop.freeze(Time.zone.parse('14:00 3 October 2018'))
      create_post('Second post')
      expect(first('.post-message')).to have_content 'Second post'
    end
  end
  scenario "user visits another profile and can see only that user's posts" do
    click_on('Logout')
    sign_up_helper('bob@bob.com', 'Bob', 'password')
    create_post('Goodbye!')
    visit '/users/1'
    expect(page).not_to have_content 'Goodbye!'
    expect(page).to have_content 'Hello!'
  end

  scenario 'Timeline has a My Profile button' do
    expect(page).to have_button('My Profile')
  end

  scenario 'User can visit own profile by clicking on profile button (in timeline)' do
    click_on('My Profile')
    expect(page).to have_current_path('/profile')
  end

  scenario 'Profile has a button to timeline' do
    visit('/profile')
    expect(page).to have_button('Home')
  end

  scenario 'User can go back to timeline from profile by clicking Home' do
    visit('/profile')
    click_on('Home')
    expect(page).to have_current_path('/')
  end

  scenario 'User can click on authors name for post to visit their profile' do
    click_on('Logout')
    sign_up_helper('seconduser@test.com', 'andres', 'password')
    click_on('TestName')
    expect(page).to have_current_path('/users/1')
  end
end