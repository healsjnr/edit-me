require 'rails_helper'
require_relative '../../app/helpers/application_helper'

RSpec.describe 'UserPages', :type => :request do

  include ApplicationHelper

  subject { page }

  it 'should return 200' do
    get new_user_registration_path
    expect(response).to have_http_status(200)
  end

  describe 'signup page' do
    before { visit new_user_registration_path }
    it 'should have signup content' do
      expect(page).to have_content('Sign up')
      expect(page).to have_title(full_title('Sign Up'))
    end
    it 'should sign you up' do
      fill_in 'First name', :with => 'Either'
      fill_in 'Last name', :with => 'Gonzalez'
      fill_in 'Email',                 :with => 'alindeman@example.com'
      fill_in 'Password',              :with => 'ilovegrapes'
      fill_in 'Password confirmation', :with => 'ilovegrapes'

      select 'writer', :from => 'user[account_type]'

      click_button 'Sign up'

      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end
end
