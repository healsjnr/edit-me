require 'rails_helper'
require_relative '../../app/helpers/application_helper'

RSpec.describe 'UserPages', :type => :request do

  include ApplicationHelper

  subject { page }
  describe 'Get Documents' do
    it 'returns all documents' do
      FactoryGirl.create :document
      expected_docs = Document.all.to_json

      get "/documents", {}, {"Accept" => "application/json"}

      expect(response.body).to eq(expected_docs)
    end

    it 'returns documents with status' do
      user = FactoryGirl.create :user
      FactoryGirl.create :document, owner: user
      FactoryGirl.create :document, status: 'new', owner: user
      expected_docs = Document.where(status: 'new').to_json

      get "/documents?status=new", {}, {"Accept" => "application/json"}

      expect(response.body).to eq(expected_docs)
    end

    it 'returns documents with owner_id' do
      user_1 = FactoryGirl.create :user, email: 'test1@email.com'
      user_2 = FactoryGirl.create :user, email: 'test2@email.com'
      FactoryGirl.create :document, owner: user_1
      FactoryGirl.create :document, owner: user_2
      expected_docs = Document.where(owner: user_2).to_json

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
      user_1 = FactoryGirl.create :user, email: 'test1@email.com'
      document = user_1.documents.build(title: 'New document', original_file_name: 'origin.doc', status: 'new')
      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }

      post "/documents", document.to_json, request_headers
      expect(response.status).to eq 200

      returned_doc = JSON.parse(response.body, symbolize_names: true)
      expect(returned_doc[:title]).to eq(document.title)
      expect(returned_doc[:status]).to eq(document.status)

      created_doc = Document.where(title: document.title, owner: user_1).first
      expect(compare_doc(document, created_doc)).to be_truthy
    end
  end
end

