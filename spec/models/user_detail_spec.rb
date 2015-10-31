require 'rails_helper'

describe UserDetail do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @user_details = user.build_user_detail(first_name: 'John', last_name: 'Doe')
  end

  subject { @user_details }

  it 'should respond to methods' do
    expect(@user_details).to respond_to :first_name
    expect(@user_details).to respond_to :last_name
    expect(@user_details).to respond_to :user
  end

  it 'should have the right user' do
    expect(@user_details.user).to eq user
  end

  it { should be_valid }

  describe 'when user is not present' do
    before { @user_details.user = nil }
    it 'should not be valid' do
      expect(@user_details).to_not be_valid
      expect(UserDetail.new(first_name: 'a', last_name: 'b')).to_not be_valid
    end
  end

end


