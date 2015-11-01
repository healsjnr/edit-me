class AddUserType < ActiveRecord::Migration
  def change
    add_column :users, :account_type, :string, null: false, default: 'writer'
    change_column :users, :account_type, :string, default: nil
  end
end
