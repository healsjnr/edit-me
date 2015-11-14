class CreateDocumentVersions < ActiveRecord::Migration
  def change
    create_table :document_versions do |t|
      t.references :uploader, references: :users, index: true, foreign_key: true
      t.string :uploader_account_type
      t.string :version
      t.references :document, index: true, foreign_key: true
      t.string :s3_link

      t.timestamps null: false
    end
  end
end
