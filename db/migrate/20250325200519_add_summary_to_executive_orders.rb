class AddSummaryToExecutiveOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :executive_orders, :summary, :text
  end
end
