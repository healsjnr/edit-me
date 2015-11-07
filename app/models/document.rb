class Document < ActiveRecord::Base
  include Filterable
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :document_version

  validates :title, presence: true
  validates :original_file_name, presence: true
  validates :status, presence: true
  validates :owner, presence: true

  scope :status, -> (status) { where status: status }
  scope :title, -> (title) { where title: title }
  scope :original_file_name, -> (fn) { where original_file_name: fn }
  scope :owner_id, -> (owner_id) { where owner: owner_id }

  def self.get_documents_for_user(user_id, params = {})
    # To do, add in assigend docs when this is available.
    Document.where(owner: user_id).filter(params)
  end

end
