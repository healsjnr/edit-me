require 'rails_helper'

RSpec.describe 'SplashPages', :type => :request do
  describe 'GET /splash_pages' do
    it 'splash page should have expected content'do
      visit 'splash_pages/splash'
      expect(page).to have_content 'edit-me'
      expect(page).to have_content 'info@edit-me.net'
    end
  end
end
