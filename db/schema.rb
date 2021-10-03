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

ActiveRecord::Schema.define(version: 2021_08_12_112357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "exchange"
    t.string "currency"
    t.string "country"
    t.string "symbol"
    t.string "kind", default: "unknown"
    t.string "status", default: "initializing"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "logo_data"
    t.text "description", default: ""
    t.boolean "observed"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dividends", force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "PLN", null: false
    t.string "asset_id", null: false
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_dividends_on_asset_id"
  end

  create_table "exchanges", id: :string, force: :cascade do |t|
    t.string "name"
    t.jsonb "trading"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "holdings", force: :cascade do |t|
    t.string "asset_id", null: false
    t.float "amount"
    t.integer "input_id"
    t.string "state"
    t.date "open_date"
    t.date "close_date"
    t.integer "open_price_cents", default: 0, null: false
    t.string "open_price_currency", default: "PLN", null: false
    t.integer "close_price_cents", default: 0, null: false
    t.string "close_price_currency", default: "PLN", null: false
    t.integer "open_commission_cents", default: 0, null: false
    t.string "open_commission_currency", default: "PLN", null: false
    t.integer "close_commission_cents", default: 0, null: false
    t.string "close_commission_currency", default: "PLN", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_id"], name: "index_holdings_on_asset_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "dividends", "assets"
  add_foreign_key "holdings", "assets"
end
