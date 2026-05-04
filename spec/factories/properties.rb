FactoryBot.define do
  factory :property do
    title { Faker::Address.community }
    address { Faker::Address.full_address }
    suburb { Faker::Address.city }
    state { Faker::Address.state_abbr }
    postcode { Faker::Address.postcode }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.between(from: 500_000, to: 2_000_000) }
    bedrooms { Faker::Number.between(from: 1, to: 5) }
    bathrooms { Faker::Number.between(from: 1, to: 3) }
    property_type { :house }
    status { :active }
    land_size_sqm { Faker::Number.between(from: 200, to: 1000) }
    floor_area_sqm { Faker::Number.between(from: 100, to: 500) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
