class CreateWarehouseLocations < ActiveRecord::Migration
    def change
        create_table :warehouse_locations do |t|
            t.string :subject
            t.integer :row_no
            t.string :warehouse
            t.string :status

            t.integer :created_by_id
            t.integer :updated_by_id
            t.timestamps null: false
        end
    end
end

