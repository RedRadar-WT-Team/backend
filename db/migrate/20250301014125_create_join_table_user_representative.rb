class CreateJoinTableUserRepresentative < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :representatives do |t|
      t.index [:user_id, :representative_id], unique: true
      t.index [:representative_id, :user_id]
    end
  end
end
