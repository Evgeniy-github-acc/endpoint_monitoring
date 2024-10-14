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

ActiveRecord::Schema[7.2].define(version: 2024_10_13_174820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "endpoint_statuses", force: :cascade do |t|
    t.bigint "endpoint_id", null: false
    t.string "status"
    t.integer "response_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endpoint_id"], name: "index_endpoint_statuses_on_endpoint_id"
  end

  create_table "endpoints", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.integer "max_response_time", null: false
    t.integer "period", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "history_days", force: :cascade do |t|
    t.bigint "endpoint_id", null: false
    t.date "date"
    t.integer "average_response_time"
    t.integer "total_response_time"
    t.string "status"
    t.integer "failed_requests_count"
    t.integer "request_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endpoint_id"], name: "index_history_days_on_endpoint_id"
  end

  add_foreign_key "endpoint_statuses", "endpoints"
  add_foreign_key "history_days", "endpoints"
end
