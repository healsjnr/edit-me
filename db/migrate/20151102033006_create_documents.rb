class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :owner, references: :users, index: true, foreign_key: true
      t.string :title, null: false
      t.string :original_file_name, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
  end
end
