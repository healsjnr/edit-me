require 'rails_helper'
require 'shared_contexts'
require_relative '../../app/helpers/application_helper'

RSpec.describe 'Document Version Pages', :type => :request do
  include_context "api request authentication helper methods"
  include_context "api request global before and after hooks"

  include ApplicationHelper

  let(:email_1) { 'test_user1@example.com' }
  let(:email_2) { 'test_user2@example.com' }
  let(:password) { 'password1234' }

  let(:user_1) { FactoryGirl.create :user, email: email_1, password: password }
  let(:user_2) { FactoryGirl.create :user, email: email_2, password: password }

  let(:doc_1) { FactoryGirl.create(:document, owner: user_1) }
  let(:doc_2) { FactoryGirl.create(:document, owner: user_2) }

  let(:doc_1_version_1) { FactoryGirl.create :document_version, uploader: user_1, document: doc_1, version: 1 }
  let(:doc_1_version_2) { FactoryGirl.create :document_version, uploader: user_1, document: doc_1, version: 2 }
  let(:doc_1_version_3) { FactoryGirl.create :document_version, uploader: user_2, document: doc_1, version: 3 }
  let(:doc_2_version_1) { FactoryGirl.create :document_version, uploader: user_2, document: doc_2, version: 1 }

  subject { page }

  describe 'Get Documents' do
    let(:expected_user_1_doc_1) { [doc_1_version_1, doc_1_version_2, doc_1_version_3].to_json }
    let(:expected_user_1_doc_2) { [].to_json }
    let(:expected_user_2_doc_1) { [].to_json } # TODO in the future this should be the same as expected_user_1_doc_1 as user_2 would be a collaborator to doc_1
    let(:expected_user_2_doc_2) { [doc_2_version_1].to_json }

    it 'returns all document versions for user' do
      doc_1_version_1.save
      doc_1_version_2.save
      doc_1_version_3.save
      doc_2_version_1.save

      sign_in(user_1)
      get "/document_versions?document_id=#{doc_1.id}", {}, {"Accept" => "application/json"}
      expect(response.body).to eq(expected_user_1_doc_1)

      sign_in(user_2)
      get "/document_versions?document_id=#{doc_2.id}", {}, {"Accept" => "application/json"}
      expect(response.body).to eq(expected_user_2_doc_2)
    end

    # TODO change this once we have collaborators
    it 'returns no document versions if the user cannot view that doc' do
      doc_1_version_1.save
      doc_1_version_2.save
      doc_1_version_3.save
      doc_2_version_1.save
      sign_in(user_1)
      get "/document_versions?document_id=#{doc_2.id}", {}, {"Accept" => "application/json"}
      expect(response.body).to eq(expected_user_1_doc_2)

      sign_in(user_2)
      get "/document_versions?document_id=#{doc_1.id}", {}, {"Accept" => "application/json"}
      expect(response.body).to eq(expected_user_2_doc_1)
    end
  end

  def create_json_request_from_object(document_version)
    document_version.serializable_hash.except(
        'version', 'id', 'created_at', 'updated_at', 'uploader'
    ).to_json
  end

  describe 'create a document version' do
    it 'should create a document version for a document' do
      doc_1_version_1.save
      doc_1_version_2.save
      doc_1_version_3.save
      doc_2_version_1.save
      document_version = doc_1.document_version.build(
          uploader: user_1,
          uploader_account_type: user_1.account_type,
          s3_link: 's3://version_4_link',
      )
      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }

      request = create_json_request_from_object(document_version)

      puts "request: #{request}"

      sign_in(user_1)
      post "/document_versions", request, request_headers
      expect(response.status).to eq 200

      new_doc = DocumentVersion.find_by(uploader: user_1, document: doc_1, version: '4')
      expect(new_doc).to_not be_nil
      expect(new_doc.s3_link).to eq(document_version.s3_link)
      expect(new_doc.version).to eq('4')
    end
  end
end

