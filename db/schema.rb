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

ActiveRecord::Schema.define(version: 20170105193748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
