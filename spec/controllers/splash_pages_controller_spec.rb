require 'rails_helper'

RSpec.describe SplashPagesController, :type => :controller do

  describe "GET splash" do
    it "returns http success" do
      visit 'splash_pages/splash'
      expect(response).to be_success
    end
  end

end
