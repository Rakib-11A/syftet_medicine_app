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

ActiveRecord::Schema.define(version: 2021_11_05_050919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "address"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "state"
    t.string "company"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_brands", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "permalink"
    t.string "meta_title"
    t.string "meta_desc"
    t.string "keywords"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "admin_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.string "permalink"
    t.string "meta_title"
    t.string "meta_desc"
    t.string "keywords"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_coupons", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "discount"
    t.integer "percentage"
    t.date "expiration"
    t.integer "maximun_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_gallery_images", force: :cascade do |t|
    t.string "image"
    t.integer "position", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_suppliers_discounts", force: :cascade do |t|
    t.integer "amount"
    t.date "date"
    t.string "discount_by"
    t.string "discount_reason"
    t.string "invoice_no"
    t.integer "invoice_id"
    t.integer "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_admin_suppliers_discounts_on_supplier_id"
  end

  create_table "admin_suppliers_invoice_items", force: :cascade do |t|
    t.text "note"
    t.integer "issued_quantity"
    t.integer "received_quantity"
    t.float "cost_price"
    t.float "sale_price"
    t.float "vat"
    t.float "total"
    t.date "expaire_date"
    t.integer "invoice_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_admin_suppliers_invoice_items_on_product_id"
  end

  create_table "admin_suppliers_invoices", force: :cascade do |t|
    t.string "no"
    t.integer "amount"
    t.date "date"
    t.float "transport_cost"
    t.boolean "is_complete", default: false
    t.date "expected_delivery"
    t.text "instruction"
    t.boolean "is_received", default: false
    t.date "receive_date"
    t.text "note"
    t.boolean "is_order", default: false
    t.string "order_state"
    t.integer "supplier_id"
    t.integer "issued_by_id"
    t.integer "received_by_id"
    t.bigint "stock_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_location_id"], name: "index_admin_suppliers_invoices_on_stock_location_id"
  end

  create_table "admin_suppliers_invoices_attachments", force: :cascade do |t|
    t.integer "invoice_id"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_suppliers_payments", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "paid_by_id"
    t.string "method"
    t.integer "amount"
    t.date "payment_date"
    t.date "value_date"
    t.string "cheque_number"
    t.string "status"
    t.boolean "confirmed"
    t.string "paid_to"
    t.integer "invoice_id"
    t.boolean "is_group_payment", default: false
    t.float "commission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_suppliers_refund_items", force: :cascade do |t|
    t.integer "refund_id"
    t.integer "invoice_item_id"
    t.float "amount"
    t.integer "quantity"
    t.float "cost_price"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_admin_suppliers_refund_items_on_product_id"
  end

  create_table "admin_suppliers_refunds", force: :cascade do |t|
    t.integer "amount"
    t.date "date"
    t.string "invoice_no"
    t.boolean "is_order", default: false
    t.string "refund_by"
    t.string "refund_reason"
    t.integer "employee_id"
    t.integer "invoice_id"
    t.integer "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_admin_suppliers_refunds_on_supplier_id"
  end

  create_table "admin_suppliers_text_messages", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "employee_id"
    t.text "content"
    t.string "direction"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.string "cover_photo"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.boolean "is_approved"
    t.integer "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "order_number"
    t.string "inquiry_type"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_checked", default: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "customer_returns", force: :cascade do |t|
    t.string "number"
    t.integer "stock_location_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "feedback_type"
    t.text "message"
    t.string "product_quality"
    t.string "product_price"
    t.text "customer_service"
    t.integer "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_checked", default: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "home_sliders", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "sub_title"
    t.string "link"
    t.integer "position", default: 1
  end

  create_table "images", force: :cascade do |t|
    t.string "viewable_type"
    t.bigint "viewable_id"
    t.integer "width"
    t.integer "height"
    t.integer "file_size"
    t.integer "position"
    t.string "content_type"
    t.text "file"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["viewable_type", "viewable_id"], name: "index_images_on_viewable_type_and_viewable_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity"
    t.decimal "price", precision: 22, scale: 6, default: "0.0"
    t.decimal "cost_price", precision: 22, scale: 6, default: "0.0"
    t.string "currency"
    t.decimal "adjustment_total", default: "0.0"
    t.decimal "promo_total", default: "0.0"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string "email"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "number"
    t.decimal "item_total", default: "0.0"
    t.decimal "total", default: "0.0"
    t.string "state"
    t.decimal "adjustment_total", default: "0.0"
    t.integer "user_id"
    t.datetime "completed_at"
    t.integer "ship_address_id"
    t.decimal "payment_total", default: "0.0"
    t.string "shipment_state"
    t.string "payment_state"
    t.string "email"
    t.string "currency"
    t.string "created_by_id"
    t.decimal "shipment_total", default: "0.0"
    t.decimal "promo_total", default: "0.0"
    t.integer "item_count"
    t.integer "approver_id"
    t.datetime "approved_at"
    t.boolean "confirmation_delivered"
    t.string "guest_token"
    t.datetime "canceled_at"
    t.integer "canceler_id"
    t.integer "store_id"
    t.date "shipment_date"
    t.integer "shipment_progress", default: 0
    t.datetime "shipped_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "special_instructions"
    t.string "collection_point"
    t.decimal "tax_total", default: "0.0"
    t.integer "admin_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.text "preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.integer "order_id"
    t.integer "payment_method_id"
    t.string "state"
    t.string "response_code"
    t.string "response_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.integer "source_id"
    t.string "source_type"
  end

  create_table "paypal_express_checkouts", force: :cascade do |t|
    t.string "token"
    t.string "payer_id"
    t.integer "order_id"
    t.string "state", default: "completed"
    t.integer "refund_id"
    t.datetime "refunded_at"
    t.string "refund_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "print_barcodes", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "print_id"
    t.index ["print_id"], name: "index_print_barcodes_on_print_id"
    t.index ["product_id"], name: "index_print_barcodes_on_product_id"
    t.index ["user_id"], name: "index_print_barcodes_on_user_id"
  end

  create_table "prints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.text "description"
    t.string "origin"
    t.string "slug"
    t.string "meta_title"
    t.text "meta_desc"
    t.string "keywords"
    t.bigint "brand_id"
    t.boolean "is_featured", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "deleted_at"
    t.integer "product_id"
    t.decimal "sale_price", precision: 22, scale: 6, default: "0.0", null: false
    t.decimal "cost_price", precision: 22, scale: 6, default: "0.0", null: false
    t.decimal "whole_sale", precision: 22, scale: 6, default: "0.0", null: false
    t.string "color_name"
    t.string "color"
    t.string "size"
    t.string "weight"
    t.string "width"
    t.string "height"
    t.string "depth"
    t.boolean "discountable", default: false
    t.boolean "is_amount", default: false
    t.decimal "discount", precision: 22, scale: 6, default: "0.0", null: false
    t.decimal "reward_point", precision: 22, scale: 6, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "track_inventory", default: true
    t.string "barcode"
    t.integer "supplier_id"
    t.integer "min_stock", default: 0
    t.boolean "pre_order"
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.integer "payment_id"
    t.decimal "amount"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "related_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "relative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "return_items", force: :cascade do |t|
    t.integer "customer_return_id"
    t.integer "line_item_id"
    t.boolean "resellable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "name"
    t.integer "rating"
    t.text "text"
    t.integer "product_id"
    t.integer "user_id"
    t.string "email"
    t.boolean "is_approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards_points", force: :cascade do |t|
    t.integer "order_id"
    t.decimal "points", precision: 22, scale: 6, default: "0.0"
    t.string "reason"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.string "tracking"
    t.string "number"
    t.decimal "cost", default: "0.0"
    t.datetime "shipped_at"
    t.integer "order_id"
    t.integer "address_id"
    t.string "state"
    t.integer "stock_location_id"
    t.decimal "adjustment_total", default: "0.0"
    t.decimal "promo_total", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shipping_method_id"
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string "name"
    t.string "display_on"
    t.datetime "deleted_at"
    t.string "admin_name"
    t.string "code"
    t.string "tracking_url"
    t.string "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "backdoor_only", default: false
  end

  create_table "stock_items", force: :cascade do |t|
    t.integer "stock_location_id"
    t.integer "product_id"
    t.integer "count_on_hand", default: 0
    t.boolean "backorderable", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_locations", force: :cascade do |t|
    t.string "name"
    t.boolean "default", default: false
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "country"
    t.string "phone"
    t.boolean "active", default: true
    t.boolean "backorderable_default", default: false
    t.boolean "propagate_all_variants", default: true
    t.string "admin_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_movements", force: :cascade do |t|
    t.integer "stock_item_id"
    t.integer "quantity", default: 0
    t.string "action"
    t.integer "originator_id"
    t.string "originator_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.string "transfer_type"
    t.string "reference"
    t.integer "source_location_id"
    t.integer "destination_location_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.text "comment"
    t.integer "user_id"
    t.integer "shipment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.string "role"
    t.string "name"
    t.integer "ship_address_id"
    t.text "tokens"
    t.string "company"
    t.float "initial_balance"
    t.date "initial_balance_date"
    t.string "mobile"
    t.string "landphone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.integer "product_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admin_suppliers_invoice_items", "products"
  add_foreign_key "admin_suppliers_invoices", "stock_locations"
  add_foreign_key "admin_suppliers_refund_items", "products"
  add_foreign_key "contacts", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "print_barcodes", "prints"
  add_foreign_key "print_barcodes", "products"
  add_foreign_key "print_barcodes", "users"
end
