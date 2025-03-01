class CreateExecutiveOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :executive_orders do |t|
      t.string :title
      t.string :html_url
      t.integer :executive_order_number
      t.datetime :signing_date

      t.timestamps
    end
  end
end
