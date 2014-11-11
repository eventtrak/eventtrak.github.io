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

ActiveRecord::Schema.define(version: 20140119181838) do

  create_table "artists", force: true do |t|
    t.string   "artist_name"
    t.string   "route_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "email"
    t.text     "description"
    t.string   "youtube"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "instagram"
  end

  create_table "attendees", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "band_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "artist_id"
    t.integer  "goal"
    t.string   "title"
    t.text     "body"
  end

  create_table "facebook_friends", force: true do |t|
    t.integer  "fbid1",      limit: 8
    t.integer  "fbid2",      limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performers", force: true do |t|
    t.integer  "artist_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_models", force: true do |t|
    t.string   "description"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "max_amount"
    t.string   "name"
  end

  create_table "tickets", force: true do |t|
    t.string   "code"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "value"
    t.boolean  "claimed"
    t.integer  "event_id"
    t.integer  "ticket_model_id"
    t.string   "name"
  end

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.boolean  "is_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_analytics", force: true do |t|
    t.string   "user_identifier"
    t.boolean  "is_registered"
    t.string   "url"
    t.integer  "action"
    t.string   "target"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  create_table "users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "password"
    t.boolean  "is_beta_tester"
    t.boolean  "is_artist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "client_ip"
    t.integer  "facebook_id",           limit: 8
    t.boolean  "has_temp_password"
    t.string   "remember_token"
    t.string   "stripe_customer_token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "venue_dates", force: true do |t|
    t.datetime "date"
    t.integer  "venue_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.integer  "capacity"
    t.integer  "min_age"
    t.string   "equipment"
    t.integer  "min_price"
    t.integer  "max_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "address"
    t.string   "url"
  end

end
