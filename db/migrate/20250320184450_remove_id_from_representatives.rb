class RemoveIdFromRepresentatives < ActiveRecord::Migration[7.1]
  def change
    remove_column :representatives, :id
  end
end
