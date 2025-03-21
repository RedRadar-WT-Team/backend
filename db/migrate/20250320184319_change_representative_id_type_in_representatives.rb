class ChangeRepresentativeIdTypeInRepresentatives < ActiveRecord::Migration[7.1]
  def change
    change_column :representatives, :id, :string
  end
end
