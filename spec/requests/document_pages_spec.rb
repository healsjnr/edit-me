require 'rails_helper'
require 'shared_contexts'
require_relative '../../app/helpers/application_helper'

RSpec.describe 'Document Pages', :type => :request do
  include_context "api request authentication helper methods"
  include_context "api request global before and after hooks"

  include ApplicationHelper

  let(:email_1) { 'test_user1@example.com' }
  let(:email_2) { 'test_user2@example.com' }
  let(:password) { 'password1234' }
  let(:user_1) { FactoryGirl.create :user, email: email_1, password: password }
  let(:user_2) { FactoryGirl.create :user, email: email_2, password: password }

  subject { page }

  def add_source(docs, source = :owner)
    docs.map { |d| d.source = source; d }
  end
  describe 'Get Documents' do
    it 'returns all documents' do
      FactoryGirl.create(:document, owner: user_1)
      FactoryGirl.create(:document, owner: user_2)
      expected_docs = add_source(Document.where(owner_id: user_1)).to_json

      sign_in(user_1)
      get "/documents", {}, {"Accept" => "application/json"}

      expect(response.body).to eq(expected_docs)
    end

    it 'returns documents with status' do
      FactoryGirl.create :document, owner: user_1
      FactoryGirl.create :document, status: 'new', owner: user_1
      FactoryGirl.create :document, status: 'new', owner: user_1
      expected_docs = add_source(Document.where(status: 'new')).to_json

      sign_in(user_1)
      get "/documents?status=new", {}, {"Accept" => "application/json"}

      expect(response.body).to eq(expected_docs)
    end

    it 'returns documents with owner_id' do
      FactoryGirl.create :document, owner: user_1
      FactoryGirl.create :document, owner: user_2
      expected_docs = add_source(Document.where(owner: user_2)).to_json

      sign_in(user_2)
      get "/documents?owner_id=2", {}, {"Accept" => "application/json"}

      expect(response.body).to eq(expected_docs)
    end
  end

  def compare_doc(actual_doc, expected_doc)
    (actual_doc.title == expected_doc.title &&
      actual_doc.original_file_name == expected_doc.original_file_name &&
      actual_doc.status == expected_doc.status)
  end

  describe 'Create documents' do
    it 'should create a valid document' do
      document = user_1.documents.build(title: 'New document', original_file_name: 'origin.doc', status: 'new')
      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }

      sign_in(user_1)
      post "/documents", document.to_json, request_headers
      expect(response.status).to eq 200

      returned_doc = JSON.parse(response.body, symbolize_names: true)
      expect(returned_doc[:title]).to eq(document.title)
      expect(returned_doc[:status]).to eq(document.status)

      created_doc = Document.where(title: document.title, owner: user_1).first
      expect(compare_doc(document, created_doc)).to be_truthy
    end

    it 'should fail to create a document for a different user' do
      document = user_1.documents.build(title: 'New document', original_file_name: 'origin.doc', status: 'new')
      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }

      sign_in(user_2)
      post "/documents", document.to_json, request_headers
      expect(response.status).to eq 403
    end
  end
end

