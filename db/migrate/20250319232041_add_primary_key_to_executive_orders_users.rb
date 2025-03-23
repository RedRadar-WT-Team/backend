class AddPrimaryKeyToExecutiveOrdersUsers < ActiveRecord::Migration[7.1]
  def change
      drop_table :executive_orders_users, if_exists: true
  
      create_table :executive_orders_users do |t|
        t.references :user, null: false, foreign_key: true
        t.references :executive_order, null: false, foreign_key: true
  
        t.timestamps
      end
  end
end
