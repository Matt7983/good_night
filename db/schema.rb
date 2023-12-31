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

ActiveRecord::Schema[7.0].define(version: 2023_08_03_170138) do
  create_table "clocks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.timestamp "clock_in", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "clock_out"
    t.integer "duration"
    t.index ["user_id"], name: "index_clocks_on_user_id"
  end

  create_table "followers", primary_key: ["follower_id", "followee_id"], charset: "utf8mb4", force: :cascade do |t|
    t.integer "followee_id", null: false
    t.integer "follower_id", null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["followee_id"], name: "index_followers_on_followee_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "clocks", "users"
end
