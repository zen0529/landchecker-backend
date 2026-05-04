class Property < ApplicationRecord
  enum :property_type, {
    house: 0,
    apartment: 1,
    townhouse: 2,
    condo: 3,
    land: 4
  }

  enum :status, {
    active: 0,
    under_contract: 1,
    sold: 2,
    withdrawn: 3
  }

  has_many :watchlist_items, dependent: :destroy
  has_many :watched_by_users, through: :watchlist_items, source: :user

  validates :title, :price, :bedrooms, :bathrooms, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :bedrooms, :bathrooms, numericality: { greater_than_or_equal_to: 0 }
  validates :property_type, :status, presence: true

  scope :active_listings, -> { where(status: :active) }
  scope :by_suburb, ->(suburb) { where(suburb: suburb) }
  scope :price_between, ->(min, max) { where(price: min..max) }
  scope :with_bedrooms, ->(n) { where(bedrooms: n) }

  # app/models/property.rb  (add this to the existing model)

  after_update_commit :broadcast_watchlist_changes, if: :relevant_changes?

  private

  def relevant_changes?
    saved_change_to_price? || saved_change_to_status?
  end

  def broadcast_watchlist_changes
    WatchlistBroadcastService.call(self)
  end
end