require 'rails_helper'
require_relative '../../app/helpers/application_helper'

RSpec.describe 'UserPages', :type => :request do

  include ApplicationHelper

  subject { page }
  describe 'Documents' do
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
end

