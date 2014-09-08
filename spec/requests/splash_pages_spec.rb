require 'rails_helper'

RSpec.describe "SplashPages", :type => :request do
  describe "GET /splash_pages" do
    it "works! (now write some real specs)" do
      visit 'splash_pages/splash'
      expect(page).to have_content 'edit-me'
      expect(page).to have_content 'info@edit-me.net'
    end
  end
end
