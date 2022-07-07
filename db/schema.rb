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

ActiveRecord::Schema[7.0].define(version: 2022_07_07_201043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.text "notes"
    t.integer "status"
    t.datetime "canceled_at"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "professional_id", null: false
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["professional_id"], name: "index_bookings_on_professional_id"
    t.index ["service_id"], name: "index_bookings_on_service_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "occupations", force: :cascade do |t|
    t.bigint "professional_id", null: false
    t.bigint "service_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_occupations_on_professional_id"
    t.index ["service_id"], name: "index_occupations_on_service_id"
  end

  create_table "product_usages", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "service_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_usages_on_product_id"
    t.index ["service_id"], name: "index_product_usages_on_service_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.integer "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professionals", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "document"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_professionals_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "weekday"
    t.integer "starts_at"
    t.integer "ends_at"
    t.integer "interval_starts_at"
    t.integer "interval_ends_at"
    t.bigint "professional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_schedules_on_professional_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.integer "duration"
    t.decimal "price", precision: 8, scale: 2
    t.boolean "is_comissioned", default: false
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_services_on_service_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.string "type", null: false
    t.datetime "integralized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.integer "uid"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "customers"
  add_foreign_key "bookings", "professionals"
  add_foreign_key "bookings", "services"
  add_foreign_key "occupations", "professionals"
  add_foreign_key "occupations", "services"
  add_foreign_key "product_usages", "products"
  add_foreign_key "product_usages", "services"
  add_foreign_key "professionals", "users"
  add_foreign_key "schedules", "professionals"
  add_foreign_key "services", "services"
  add_foreign_key "stocks", "products"
end
