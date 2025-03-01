class CreateJoinTableUserExecutiveOrder < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :executive_orders do |t|
      t.index [:user_id, :executive_order_id], unique: true
      t.index [:executive_order_id, :user_id]
    end
  end
end
