class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :user_id, uniqueness: { scope: :property_id, message: "already watching this property" }
  validates :last_seen_price, numericality: { greater_than: 0 }, allow_nil: true
end