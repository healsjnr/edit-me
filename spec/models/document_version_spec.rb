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
  end

  describe 'validate fields' do
    it 'should respond to methods' do
      expect(@document_version).to respond_to :uploader
      expect(@document_version).to respond_to :uploader_account_type
      expect(@document_version).to respond_to :document
      expect(@document_version).to respond_to :s3_link
      expect(@document_version).to respond_to :version
    end
  end


  describe 'json parsing' do
    it 'should parse to JSON correctly' do
      json_doc = JSON.parse(@document_version.to_json, symbolize_names: true)
      expect(json_doc[:uploader]).to_not be_nil
      expect(json_doc[:uploader][:first_name]).to eq(user_1.first_name)
      expect(json_doc[:uploader][:last_name]).to eq(user_1.last_name)
      expect(json_doc[:uploader][:email]).to eq(user_1.email)
    end
  end

  def compare_doc_versions(expected_doc, actual_doc)
    expect(expected_doc.uploader).to eq(actual_doc.uploader)
    expect(expected_doc.uploader_account_type).to eq(actual_doc.uploader_account_type)
    expect(expected_doc.document).to eq(actual_doc.document)
    expect(expected_doc.s3_link).to eq(actual_doc.s3_link)
    expect(expected_doc.version).to eq(actual_doc.version)
  end

  describe 'create document_versions' do
    it 'should create a doc given the set of params' do
      params = {
          uploader_id: user_1.id,
          uploader_account_type: user_1.account_type,
          document_id: document_1.id,
          s3_link: 's3://test.link'
      }
      expected_doc = document_1.document_version.build(
          uploader: user_1,
          uploader_account_type: params[:uploader_account_type],
          s3_link: params[:s3_link],
          version: 1
      )

      doc_version = DocumentVersion.create_document(params)
      doc_version.save
      compare_doc_versions(expected_doc, doc_version)

      saved_doc = DocumentVersion.find_by(uploader: user_1, document: document_1, version: 1)
      compare_doc_versions(expected_doc, saved_doc)
    end
  end
end
