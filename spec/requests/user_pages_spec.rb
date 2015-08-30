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
  end

#  describe 'user profile page' do
#    before { visit user_path(user) }
#    it 'should return 200' do
#      get user_path(user)
#      expect(response).to have_http_status(200)
#    end
#
#    it 'should render user data' do
#      expect(page).to have_content('Name:')
#      expect(page).to have_content('Email:')
#      expect(page).to have_content(user.first_name)
#      expect(page).to have_content(user.last_name)
#      expect(page).to have_content(user.email)
#      expect(page).to have_title(full_title(user.name))
#    end
#  end
end
