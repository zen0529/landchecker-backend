class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 15, scale: 2, null: false
      t.integer :bedrooms, null: false
      t.integer :bathrooms, null: false
      t.integer :property_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :address
      t.string :suburb
      t.string :state
      t.string :postcode
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :land_size_sqm, precision: 10, scale: 2
      t.decimal :floor_area_sqm, precision: 10, scale: 2
      t.string :images, array: true, default: []
      t.string :features, array: true, default: []

      t.timestamps
    end

    add_index :properties, :status
    add_index :properties, :price
    add_index :properties, :bedrooms
    add_index :properties, :property_type
    add_index :properties, :suburb
    add_index :properties, [:status, :property_type, :bedrooms, :price], name: 'index_properties_on_filters'
    add_index :properties, :latitude
    add_index :properties, :longitude
  end
end