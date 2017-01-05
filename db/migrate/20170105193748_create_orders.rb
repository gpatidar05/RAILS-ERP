class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :subject
      t.integer :subtotal
      t.integer :tax
      t.integer :grand_total
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps null: false
    end
  end
end
