class DocumentVersion < ActiveRecord::Base
  include Filterable
  belongs_to :document
  belongs_to :uploader, class_name: 'User', foreign_key: 'uploader_id'

  validates :uploader, presence: true
  validates :uploader_account_type, presence: true
  validates :version, presence: true
  validates :document, presence: true
  validates :s3_link, presence: true

  scope :uploader_account_type, -> (account_type) { where uploader_account_type: account_type }
  scope :uploader, -> (uploader_id) { where uploader: uploader_id }
  scope :version, -> (version) { where version: version }
  scope :document, -> (doc_id) { where document: doc_id }

  def as_json(options = {})
    super(
        include: [{
            uploader: { only: User::JSON_NAME_FIELDS}
        }]
    )
  end
end
