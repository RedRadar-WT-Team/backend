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

ActiveRecord::Schema[7.1].define(version: 2025_03_26_015442) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "executive_orders", force: :cascade do |t|
    t.string "title"
    t.string "html_url"
    t.integer "executive_order_number"
    t.datetime "publication_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
    t.string "pdf_url"
  end

  create_table "executive_orders_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "executive_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["executive_order_id"], name: "index_executive_orders_users_on_executive_order_id"
    t.index ["user_id"], name: "index_executive_orders_users_on_user_id"
  end

  create_table "representatives", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "photo_url"
    t.string "party"
    t.string "state"
    t.string "district"
    t.string "area"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "representatives_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "representative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["representative_id"], name: "index_representatives_users_on_representative_id"
    t.index ["user_id"], name: "index_representatives_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "executive_orders_users", "executive_orders"
  add_foreign_key "executive_orders_users", "users"
  add_foreign_key "representatives_users", "representatives"
  add_foreign_key "representatives_users", "users"
end
