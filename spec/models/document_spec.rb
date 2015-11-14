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

    def check_source(results, expected_source)
      results.each { |r| expect(r.source).to eq(expected_source)}
    end

    it 'should only returns documents for the right user' do
      results_1 = Document.get_documents_for_user(user_1.id)
      expect(results_1).to eq(@user_1_docs)
      check_source(results_1, :owner)
      results_2 = Document.get_documents_for_user(user_2.id)
      expect(results_2).to eq(@user_2_docs)
      check_source(results_2, :owner)
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

  describe 'as json' do
    it 'should include owner details' do
      json_doc = JSON.parse(@document.to_json, symbolize_names: true)
      p json_doc
      expect(json_doc[:owner]).to_not be_nil
      expect(json_doc[:owner][:first_name]).to eq(user.first_name)
      expect(json_doc[:owner][:last_name]).to eq(user.last_name)
    end

    def compare_doc_version(doc_version_hash, doc_version)
      expect(doc_version_hash[:version]).to eq(doc_version.version)
      expect(doc_version_hash[:s3_link]).to eq(doc_version.s3_link)
      expect(doc_version_hash[:uploader_id]).to eq(doc_version.uploader.id)
      expect(doc_version_hash[:uploader_account_type]).to eq(doc_version.uploader_account_type)
      expect(doc_version_hash[:uploader][:first_name]).to eq(doc_version.uploader.first_name)
      expect(doc_version_hash[:uploader][:last_name]).to eq(doc_version.uploader.last_name)
      expect(doc_version_hash[:uploader][:email]).to eq(doc_version.uploader.email)
    end

    it 'should include document version details' do
      document_version_1 = @document.document_version.build(
          uploader: user_1,
          uploader_account_type: user_1.account_type,
          version: '1',
          s3_link: 'test_link_1'
      )
      document_version_2 = @document.document_version.build(
          uploader: user_2,
          uploader_account_type: user_1.account_type,
          version: '2',
          s3_link: 'test_link_2'
      )
      @document.save

      json_doc = JSON.parse(@document.to_json, symbolize_names: true)
      expect(json_doc[:document_version]).to_not be_nil

      doc_version = json_doc[:document_version]
      expect(doc_version.length).to eq(2)
      compare_doc_version(doc_version[0], document_version_1)
      compare_doc_version(doc_version[1], document_version_2)
    end

  end
end
