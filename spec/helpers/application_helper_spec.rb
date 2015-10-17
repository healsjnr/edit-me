require 'rails_helper'

describe ApplicationHelper do
  describe 'full_title' do
    it 'should include the page title' do
      expect(full_title("foo")).to match(/foo/)
    end
    it 'should include the base title' do
      expect(full_title("foo")).to match(/^Edit.me/)
    end
    it 'should not include a bar for the home page' do
      expect(full_title("")).not_to match(/\|/)
    end
  end

  describe 'current user' do
    let(:signed_in_user) { FactoryGirl.create(:user) }
    it 'should not yield block when current user is not signed in' do
      current_user_valid(signed_in_user, -1) do
        fail 'Block should not be executed.'
      end
    end

    it 'should yield the block when user is signed in' do
      test_passed = false
      current_user_valid(signed_in_user, signed_in_user.id.to_s) do
        test_passed = true
      end
      expect(test_passed).to be(true)
    end
  end
end