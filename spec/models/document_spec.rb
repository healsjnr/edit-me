require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_1) { FactoryGirl.create(:user, email: 'email_1@test.com', password: 'password1234') }
  let(:user_2) { FactoryGirl.create(:user, email: 'email_2@test.com', password: 'password1234') }

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

  describe 'return documents for user' do
    before do
      @user_1_docs = [
          user_1.documents.build(title: 'User 1 document 1', original_file_name: 'origin1.doc', status: 'new'),
          user_1.documents.build(title: 'User 1 document 2', original_file_name: 'origin2.doc', status: 'active')
      ]
      user_1.save
      @user_2_docs = [
          user_2.documents.build(title: 'User 2 document 1', original_file_name: 'origin3.doc', status: 'new')
      ]
      user_2.save
    end

    it 'should only returns documents for the right user' do
      results_1 = Document.get_documents_for_user(user_1.id)
      expect(results_1).to eq(@user_1_docs)
      results_2 = Document.get_documents_for_user(user_2.id)
      expect(results_2).to eq(@user_2_docs)
      expect(results_1).to_not eq(results_2)
    end

    it 'should return only documents matching the filter criteria' do
      test_doc = @user_1_docs.first
      test_status = test_doc.status
      results_status = Document.get_documents_for_user(user_1.id, status: test_status)
      expect(results_status.size).to be(1)
      expect(results_status.first).to eq(test_doc)

      test_title = test_doc.title
      results_title = Document.get_documents_for_user(user_1.id, title: test_title)
      expect(results_title.size).to be(1)
      expect(results_title.first).to eq(test_doc)

      test_origin_fn = test_doc.original_file_name
      results_fn = Document.get_documents_for_user(user_1.id, original_file_name: test_origin_fn)
      expect(results_fn.size).to be(1)
      expect(results_fn.first).to eq(test_doc)
    end

    it 'should nothing when filter doesnt match' do
      results_status = Document.get_documents_for_user(user_1.id, status: 'not a status')
      expect(results_status.size).to eq 0
      expect(results_status).to eq []
    end

    it 'should return nothing for the wrong owner id' do
      results_1 = Document.get_documents_for_user(user_1.id, owner_id: user_2.id)
      expect(results_1.size).to be 0
      expect(results_1).to eq []
    end
  end
end
