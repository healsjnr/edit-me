class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.belongs_to :user, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.timestamps null: false
    end
  end
end
