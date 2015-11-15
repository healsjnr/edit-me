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
  scope :uploader_id, -> (uploader_id) { where uploader: uploader_id }
  scope :version, -> (version) { where version: version }
  scope :document_id, -> (doc_id) { where document: doc_id }

  def self.get_doc_versions(user, params)
    allowed_docs = find_allowed_docs(user)
    # To do, add in collaborator docs when this is available.
    all_docs = DocumentVersion.filter(params)
    all_docs.select { |d| allowed_docs.include?(d.document) }
  end

  def self.create_document(doc_version_params)
    doc_id = doc_version_params[:document_id]
    doc = Document.find(doc_id)
    new_version = get_max_version(doc)
    params = doc_version_params.merge(version: new_version)
    doc.document_version.build(params)
  end

  def as_json(options = {})
    super(
        include: [{
            uploader: { only: User::JSON_NAME_FIELDS}
        }]
    )
  end

  private
  def self.get_max_version(document)
    # TODO Version needs to be an Int
    current_version = document.document_version.map { |d| d.version }.max || 0
    current_version.to_i + 1
  end

  def self.find_allowed_docs(user)
    # TODO add collaborators to this when it exists
    Document.where(owner: user)
  end
end
