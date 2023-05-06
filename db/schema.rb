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

ActiveRecord::Schema[7.0].define(version: 2023_05_06_233211) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
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

  create_table "anamnesis_sheets", force: :cascade do |t|
    t.boolean "recent_cirurgy"
    t.text "recent_cirurgy_details"
    t.boolean "cronic_diseases"
    t.text "cronic_diseases_details"
    t.boolean "pregnant"
    t.boolean "lactating"
    t.text "medicine_usage"
    t.string "skin_type"
    t.boolean "skin_acne"
    t.boolean "skin_scars"
    t.boolean "skin_spots"
    t.boolean "skin_normal"
    t.boolean "psoriasis"
    t.boolean "dandruff"
    t.boolean "skin_peeling"
    t.text "skin_peeling_details"
    t.boolean "cosmetic_allergies"
    t.text "cosmetic_allergies_details"
    t.boolean "chemical_allergies"
    t.text "chemical_allergies_details"
    t.boolean "food_allergies"
    t.text "food_allergies_details"
    t.boolean "alcohol"
    t.boolean "tobacco"
    t.boolean "coffee"
    t.boolean "other_drugs"
    t.text "other_drugs_details"
    t.text "sleep_details"
    t.boolean "has_period"
    t.text "period_details"
    t.boolean "had_therapy_before"
    t.text "therapy_details"
    t.text "current_main_concern"
    t.text "change_motivations"
    t.text "emotion"
    t.boolean "confidentiality_aggreement"
    t.boolean "image_usage_aggreement"
    t.boolean "responsibility_aggreement"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_anamnesis_sheets_on_customer_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount"
    t.boolean "is_gift"
    t.decimal "discount"
    t.decimal "discounted_value"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xml_url"
    t.string "pdf_url"
    t.string "error_message", default: [], array: true
    t.string "reference"
    t.integer "status"
    t.decimal "billed_amount"
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
    t.bigint "bill_id"
    t.index ["bill_id"], name: "index_bookings_on_bill_id"
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["professional_id"], name: "index_bookings_on_professional_id"
    t.index ["service_id"], name: "index_bookings_on_service_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "street_address"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", default: 1
    t.date "birth_date"
    t.string "gender"
    t.integer "number"
    t.string "complement"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "gift_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "bill_id"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "inline_items"
    t.index ["bill_id"], name: "index_gift_cards_on_bill_id"
    t.index ["booking_id"], name: "index_gift_cards_on_booking_id"
  end

  create_table "gifted_services", force: :cascade do |t|
    t.uuid "gift_card_id", null: false
    t.bigint "service_id", null: false
    t.decimal "discount"
    t.decimal "price_override"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gift_card_id"], name: "index_gifted_services_on_gift_card_id"
    t.index ["service_id"], name: "index_gifted_services_on_service_id"
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
    t.text "description"
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
  add_foreign_key "anamnesis_sheets", "customers"
  add_foreign_key "bookings", "bills"
  add_foreign_key "bookings", "customers"
  add_foreign_key "bookings", "professionals"
  add_foreign_key "bookings", "services"
  add_foreign_key "customers", "users"
  add_foreign_key "gift_cards", "bills"
  add_foreign_key "gift_cards", "bookings"
  add_foreign_key "gifted_services", "gift_cards"
  add_foreign_key "gifted_services", "services"
  add_foreign_key "occupations", "professionals"
  add_foreign_key "occupations", "services"
  add_foreign_key "product_usages", "products"
  add_foreign_key "product_usages", "services"
  add_foreign_key "professionals", "users"
  add_foreign_key "schedules", "professionals"
  add_foreign_key "services", "services"
  add_foreign_key "stocks", "products"
end
