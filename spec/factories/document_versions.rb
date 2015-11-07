FactoryGirl.define do
  factory :document_version do
    user factory: :user
    version "1"
    document factory: :document
    uploader_account_type "writer"
    s3_link "s3://upload/bucked"
  end

end
