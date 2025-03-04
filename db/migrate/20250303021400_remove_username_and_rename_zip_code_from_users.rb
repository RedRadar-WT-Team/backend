class RemoveUsernameAndRenameZipCodeFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :username
    rename_column :users, :zip_code, :zip
  end
end
