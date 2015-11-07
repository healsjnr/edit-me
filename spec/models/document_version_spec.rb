require 'rails_helper'

RSpec.describe DocumentVersion, type: :model do
  let(:user_1) { FactoryGirl.create(:user, email: 'email_1@test.com', password: 'password1234') }
  let(:user_2) { FactoryGirl.create(:user, email: 'email_2@test.com', password: 'password1234') }
  let(:document_1) { FactoryGirl.create(:document, owner: user_1)}
  before do
    @document_version = document_1.document_version.build(
        uploader: user_1,
        uploader_account_type: user_1.account_type,
        version: '1',
        s3_link: 'test_link'
    )
    p @document_version
  end


  it 'should respond to methods' do
    expect(@document_version).to respond_to :uploader
    expect(@document_version).to respond_to :uploader_account_type
    expect(@document_version).to respond_to :document
    expect(@document_version).to respond_to :s3_link
    expect(@document_version).to respond_to :version
  end
end
