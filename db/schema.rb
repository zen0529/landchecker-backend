# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_02_071036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string "address"
    t.integer "bathrooms"
    t.integer "bedrooms"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "features", default: [], array: true
    t.float "floor_area_sqm"
    t.string "images", default: [], array: true
    t.float "land_size_sqm"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "postcode"
    t.integer "price"
    t.integer "property_type"
    t.string "state"
    t.integer "status"
    t.string "suburb"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "saved_searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "filters", default: {}
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["filters"], name: "index_saved_searches_on_filters", using: :gin
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "watchlist_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "last_seen_price", precision: 15, scale: 2
    t.text "notes"
    t.datetime "notified_at"
    t.bigint "property_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["property_id"], name: "index_watchlist_items_on_property_id"
    t.index ["user_id", "property_id"], name: "index_watchlist_items_on_user_id_and_property_id", unique: true
    t.index ["user_id"], name: "index_watchlist_items_on_user_id"
  end

  add_foreign_key "saved_searches", "users"
  add_foreign_key "watchlist_items", "properties"
  add_foreign_key "watchlist_items", "users"
end
