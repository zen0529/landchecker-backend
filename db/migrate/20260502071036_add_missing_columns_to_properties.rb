class AddMissingColumnsToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :land_size_sqm,  :float
    add_column :properties, :floor_area_sqm, :float
    add_column :properties, :images,         :string, array: true, default: []
    add_column :properties, :features,       :string, array: true, default: []
  end
end