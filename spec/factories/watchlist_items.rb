FactoryBot.define do
  factory :watchlist_item do
    user
    property
    notes { Faker::Lorem.sentence }
    last_seen_price { property.price }
  end
end
