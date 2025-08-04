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

ActiveRecord::Schema[8.0].define(version: 2025_08_02_175837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "invoices", force: :cascade do |t|
    t.string "series"
    t.string "folio"
    t.datetime "issued_at"
    t.string "issuer_rfc"
    t.string "issuer_name"
    t.string "receiver_rfc"
    t.string "receiver_name"
    t.decimal "subtotal", precision: 15, scale: 2
    t.decimal "total", precision: 15, scale: 2
    t.string "uuid"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "issuer_fiscal_regime"
    t.string "issuer_postal_code"
    t.string "receiver_fiscal_regime"
    t.string "receiver_tax_zip_code"
    t.string "receiver_cfdi_use"
    t.string "payment_method"
    t.string "payment_form"
    t.string "currency"
    t.string "exportation"
    t.decimal "tax_rate", precision: 5, scale: 4
    t.decimal "tax_base", precision: 15, scale: 2
    t.decimal "tax_amount", precision: 15, scale: 2
  end

  create_table "payment_complements", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "uuid"
    t.datetime "payment_date"
    t.decimal "total"
    t.string "xml_url"
    t.string "pdf_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payment_complements_on_invoice_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payment_complements", "invoices"
end
