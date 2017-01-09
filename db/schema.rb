# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170108084518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "unit"
    t.decimal  "tax"
    t.string   "manufacturer"
    t.string   "description"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "customer_id"
    t.string   "phone_mobile"
    t.string   "phone_work"
    t.string   "designation"
    t.string   "salutation"
    t.string   "department"
    t.string   "primary_street"
    t.string   "primary_city"
    t.string   "primary_state"
    t.string   "primary_country"
    t.string   "primary_postal_code"
    t.string   "alternative_street"
    t.string   "alternative_city"
    t.string   "alternative_state"
    t.string   "alternative_country"
    t.string   "alternative_postal_code"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.string   "type"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.string   "decription"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.boolean  "primary",              default: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "item_images", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "supplier_id"
    t.string   "unit"
    t.decimal  "tax"
    t.integer  "item_in_stock"
    t.integer  "max_level"
    t.integer  "min_level"
    t.decimal  "selling_price"
    t.decimal  "purchase_price"
    t.string   "item_description"
    t.string   "purchase_description"
    t.string   "selling_description"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "decription"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.integer  "subtotal"
    t.integer  "tax"
    t.integer  "grand_total"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "purchase_order_items", force: :cascade do |t|
    t.integer  "purchase_order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.decimal  "total"
    t.decimal  "unit_price"
    t.decimal  "discount"
    t.decimal  "item_total"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "subject"
    t.decimal  "total_price"
    t.decimal  "sub_total"
    t.decimal  "tax"
    t.decimal  "grand_total"
    t.string   "description"
    t.integer  "supplier_user_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.string   "country"
    t.string   "supplier_currency"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "role"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warehouse_locations", force: :cascade do |t|
    t.string   "subject"
    t.integer  "row_no"
    t.string   "warehouse"
    t.string   "status"
    t.string   "description"
    t.integer  "rack_from"
    t.integer  "rack_to"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
