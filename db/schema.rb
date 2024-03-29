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

ActiveRecord::Schema.define(version: 2020_05_13_102710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer "driver_id"
    t.integer "homeowner_id"
    t.decimal "price"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "complete", default: false
    t.boolean "withdrawn", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_intent", default: ""
    t.boolean "paid", default: false, null: false
    t.string "calendar_event_id", default: "", null: false
    t.integer "rating", default: 0, null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_conversations_on_recipient_id_and_sender_id", unique: true
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "car_info", default: "", null: false
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "homeowners", force: :cascade do |t|
    t.bigint "user_id"
    t.text "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "driveway_description"
    t.decimal "driveway_price"
    t.date "last_modified"
    t.text "activation_code"
    t.boolean "driveway_verified", default: false
    t.integer "total_ratings", default: 0
    t.integer "number_ratings", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "paypal_email", default: "", null: false
    t.datetime "active_start"
    t.datetime "active_end"
    t.index ["user_id"], name: "index_homeowners_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "access_token"
    t.string "refresh_token"
    t.integer "expires_at"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "withdrawal_requests", force: :cascade do |t|
    t.bigint "homeowner_id"
    t.decimal "amount"
    t.date "request_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false, null: false
    t.index ["homeowner_id"], name: "index_withdrawal_requests_on_homeowner_id"
  end

  add_foreign_key "drivers", "users"
  add_foreign_key "homeowners", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "withdrawal_requests", "homeowners"
end
