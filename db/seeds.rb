# db/seeds.rb

require "faker"

puts "🌱 Clearing existing data..."
WatchlistItem.delete_all
SavedSearch.delete_all
Property.delete_all
User.delete_all

# ─────────────────────────────────────────
# USERS
# ─────────────────────────────────────────
puts "👤 Seeding users..."

# One predictable user so you can always log in easily during development
admin = User.create!(
  first_name:    "aldren",
  last_name:     "arcenal",
  email:         "aldren@gmail.com",
  password:      "aldren123",
  password_confirmation: "aldren123"
)

# A second predictable user to test watchlist isolation
other_user = User.create!(
  first_name:    "jane",
  last_name:     "smith",
  email:         "jane@example.com",
  password:      "jane123",
  password_confirmation: "jane123"
)

# Random users
random_users = 8.times.map do
  User.create!(
    first_name:            Faker::Name.first_name,
    last_name:             Faker::Name.last_name,
    email:                 Faker::Internet.unique.email,
    password:              "password123",
    password_confirmation: "password123"
  )
end

all_users = [admin, other_user] + random_users
puts "  → #{all_users.count} users created"

# ─────────────────────────────────────────
# PROPERTIES
# ─────────────────────────────────────────
puts "🏠 Seeding properties..."

SUBURBS = [
  { suburb: "Paddington",    state: "NSW", postcode: "2021" },
  { suburb: "Bondi",         state: "NSW", postcode: "2026" },
  { suburb: "Surry Hills",   state: "NSW", postcode: "2010" },
  { suburb: "Newtown",       state: "NSW", postcode: "2042" },
  { suburb: "Manly",         state: "NSW", postcode: "2095" },
  { suburb: "Fitzroy",       state: "VIC", postcode: "3065" },
  { suburb: "Richmond",      state: "VIC", postcode: "3121" },
  { suburb: "St Kilda",      state: "VIC", postcode: "3182" },
  { suburb: "South Yarra",   state: "VIC", postcode: "3141" },
  { suburb: "Collingwood",   state: "VIC", postcode: "3066" },
  { suburb: "New Farm",      state: "QLD", postcode: "4005" },
  { suburb: "Paddington",    state: "QLD", postcode: "4064" },
  { suburb: "West End",      state: "QLD", postcode: "4101" },
  { suburb: "Fremantle",     state: "WA",  postcode: "6160" },
  { suburb: "Subiaco",       state: "WA",  postcode: "6008" },
].freeze

PROPERTY_FEATURES = [
  "Air conditioning", "Swimming pool", "Double garage", "Solar panels",
  "Ducted heating", "Dishwasher", "Built-in wardrobes", "Outdoor entertaining",
  "Alarm system", "Garden shed", "Intercom", "Balcony", "Study",
  "Home theatre", "Floorboards", "Granite benchtops", "Ensuite"
].freeze

PLACEHOLDER_IMAGES = [
  "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800",
  "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800",
  "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800",
  "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800",
  "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800",
  "https://images.unsplash.com/photo-1494526585095-c41746248156?w=800",
].freeze

property_types = Property.property_types.keys  # ["house", "apartment", "townhouse", "condo", "land"]
statuses       = Property.statuses.keys         # ["active", "under_contract", "sold", "withdrawn"]

# Weight statuses so most properties are active — more realistic
STATUS_WEIGHTS = {
  "active"           => 60,
  "under_contract"   => 15,
  "sold"             => 20,
  "withdrawn"        => 5
}.freeze

def weighted_status
  pool = STATUS_WEIGHTS.flat_map { |status, weight| [status] * weight }
  pool.sample
end

properties = []

80.times do
  location = SUBURBS.sample
  type     = property_types.sample
  status   = weighted_status

  # Tune price ranges to property type
  price = case type
          when "land"      then Faker::Number.between(from: 200_000,   to: 800_000)
          when "apartment", "condo"
                                Faker::Number.between(from: 350_000,   to: 1_200_000)
          when "townhouse" then Faker::Number.between(from: 500_000,   to: 1_500_000)
          else                  Faker::Number.between(from: 600_000,   to: 4_000_000)
          end

  # Land has no floor area
  floor_area = type == "land" ? nil : Faker::Number.between(from: 60, to: 400)

  bedrooms  = type == "land" ? 0 : Faker::Number.between(from: 1, to: 6)
  bathrooms = type == "land" ? 0 : [bedrooms - 1, 1].max + [0, 0, 0, 1].sample

  properties << Property.create!(
    title:           "#{Faker::Address.street_address}, #{location[:suburb]}",
    description:     Faker::Lorem.paragraphs(number: 3).join("\n\n"),
    price:           price,
    bedrooms:        bedrooms,
    bathrooms:       bathrooms,
    property_type:   type,
    status:          status,
    address:         Faker::Address.street_address,
    suburb:          location[:suburb],
    state:           location[:state],
    postcode:        location[:postcode],
    latitude:        Faker::Address.latitude,
    longitude:       Faker::Address.longitude,
    land_size_sqm:   Faker::Number.between(from: 150, to: 1200),
    floor_area_sqm:  floor_area,
    images:          PLACEHOLDER_IMAGES.sample(Faker::Number.between(from: 2, to: 5)),
    features:        PROPERTY_FEATURES.sample(Faker::Number.between(from: 3, to: 8))
  )
end

puts "  → #{properties.count} properties created"

# ─────────────────────────────────────────
# WATCHLIST ITEMS
# ─────────────────────────────────────────
puts "❤️  Seeding watchlist items..."

watchlist_count = 0

all_users.each do |user|
  # Each user watches 3–8 random properties, no duplicates
  properties.sample(Faker::Number.between(from: 3, to: 8)).each do |property|
    WatchlistItem.create!(
      user:            user,
      property:        property,
      notes:           [nil, nil, Faker::Lorem.sentence].sample,  # notes are optional
      last_seen_price: property.price
    )
    watchlist_count += 1
  end
end

puts "  → #{watchlist_count} watchlist items created"

# ─────────────────────────────────────────
# SAVED SEARCHES
# ─────────────────────────────────────────
puts "🔍 Seeding saved searches..."

SAMPLE_SEARCHES = [
  { name: "Sydney apartments under 1M",  filters: { suburb: "Bondi", property_type: "apartment", max_price: 1_000_000 } },
  { name: "Melbourne houses 3+ beds",    filters: { state: "VIC", property_type: "house", min_bedrooms: 3 } },
  { name: "Affordable townhouses",       filters: { property_type: "townhouse", max_price: 800_000 } },
  { name: "QLD active listings",         filters: { state: "QLD", status: "active" } },
  { name: "Large family homes",          filters: { property_type: "house", min_bedrooms: 4, min_price: 1_000_000 } },
].freeze

saved_search_count = 0

all_users.each do |user|
  SAMPLE_SEARCHES.sample(Faker::Number.between(from: 1, to: 3)).each do |search|
    SavedSearch.create!(
      user:    user,
      name:    search[:name],
      filters: search[:filters]
    )
    saved_search_count += 1
  end
end

puts "  → #{saved_search_count} saved searches created"

# ─────────────────────────────────────────
# SUMMARY
# ─────────────────────────────────────────
puts ""
puts "✅ Done! Database seeded."
puts "──────────────────────────────"
puts "  Users:          #{User.count}"
puts "  Properties:     #{Property.count}"
puts "  Watchlist items:#{WatchlistItem.count}"
puts "  Saved searches: #{SavedSearch.count}"
puts "──────────────────────────────"
puts ""
puts "🔑 Login credentials:"
puts "  dev@example.com  / password123"
puts "  jane@example.com / password123"