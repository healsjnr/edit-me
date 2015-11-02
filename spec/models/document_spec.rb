require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @document = user.documents.build(title: 'New document', original_file_name: 'origin.doc', status: 'new')
  end


  it 'should respond to methods' do
    expect(@document).to respond_to :title
    expect(@document).to respond_to :original_file_name
    expect(@document).to respond_to :status
    expect(@document).to respond_to :owner
  end

  describe 'validate a document' do
    it 'that is valid' do
      expect(@document).to be_valid
    end
    it 'fails when invalid' do
      doc = @document.dup
      doc.owner = nil
      expect(doc).to_not be_valid
    end
  end
end
