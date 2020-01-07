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

ActiveRecord::Schema.define(version: 2020_01_02_202034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_brands", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_insurances", force: :cascade do |t|
    t.date "date"
    t.string "license_number"
    t.bigint "car_id"
    t.index ["car_id"], name: "index_car_insurances_on_car_id"
  end

  create_table "car_owners", force: :cascade do |t|
    t.string "name"
    t.integer "license_number"
  end

  create_table "cars", force: :cascade do |t|
    t.string "model"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.bigint "car_brand_id"
    t.text "description"
    t.integer "transmission"
    t.date "release_date"
    t.bigint "car_owner_id"
    t.index ["car_brand_id"], name: "index_cars_on_car_brand_id"
    t.index ["car_owner_id"], name: "index_cars_on_car_owner_id"
  end

  create_table "passengers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "gender"
    t.bigint "car_id"
    t.string "email"
    t.index ["car_id"], name: "index_passengers_on_car_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: false
    t.integer "role", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
