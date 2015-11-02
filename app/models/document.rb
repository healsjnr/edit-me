class Document < ActiveRecord::Base
  #include Filterable
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :title, presence: true
  validates :original_file_name, presence: true
  validates :status, presence: true
  validates :owner, presence: true

  scope :status, -> (status) { where status: status }
  scope :owner_id, -> (owner_id) { where owner: owner_id}

end
