# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_04_074554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "country"
    t.string "state"
    t.integer "pin"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "shopify_customer_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email_id"
    t.integer "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_participant_chance", default: 0
  end

  create_table "products", force: :cascade do |t|
    t.string "shopify_product_title"
    t.bigint "shopify_product_id"
    t.boolean "has_variant"
    t.integer "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "raffles", force: :cascade do |t|
    t.string "title"
    t.datetime "launch_date_time"
    t.string "delivery_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inventory"
    t.integer "variant_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "raffle_id"
    t.integer "customer_id"
    t.string "type_of_customer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "shop_id"
    t.text "email_body_for_winner"
    t.text "email_body_for_participant"
    t.text "email_body_for_registration"
    t.text "email_body_for_customer_registration_verification"
    t.integer "purchase_window"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_runner"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.string "title"
    t.integer "inventory_quantity"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shopify_variant_id"
  end

end
