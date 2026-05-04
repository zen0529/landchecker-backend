class CreateWatchlistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :watchlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.text :notes
      t.decimal :last_seen_price, precision: 15, scale: 2
      t.datetime :notified_at

      t.timestamps
    end

    add_index :watchlist_items, [:user_id, :property_id], unique: true
  end
end