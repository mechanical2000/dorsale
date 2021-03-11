# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_11_131928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "dorsale_addresses", id: :serial, force: :cascade do |t|
    t.string "street"
    t.string "street_bis"
    t.string "city"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "addressable_id"
    t.string "addressable_type"
    t.index ["addressable_id"], name: "index_dorsale_addresses_on_addressable_id"
    t.index ["addressable_type"], name: "index_dorsale_addresses_on_addressable_type"
  end

  create_table "dorsale_alexandrie_attachment_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_alexandrie_attachments", id: :serial, force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.string "file"
    t.integer "sender_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "attachment_type_id"
    t.index ["attachable_id"], name: "index_dorsale_alexandrie_attachments_on_attachable_id"
    t.index ["attachable_type"], name: "index_dorsale_alexandrie_attachments_on_attachable_type"
    t.index ["attachment_type_id"], name: "index_dorsale_alexandrie_attachments_on_attachment_type_id"
    t.index ["sender_id"], name: "index_dorsale_alexandrie_attachments_on_sender_id"
  end

  create_table "dorsale_billing_machine_invoice_lines", id: :serial, force: :cascade do |t|
    t.integer "invoice_id"
    t.text "label"
    t.decimal "quantity"
    t.string "unit"
    t.decimal "unit_price"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat_rate"
    t.integer "position", default: 0, null: false
    t.index ["invoice_id"], name: "index_dorsale_billing_machine_invoice_lines_on_invoice_id"
  end

  create_table "dorsale_billing_machine_invoices", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.string "customer_type"
    t.integer "payment_term_id"
    t.date "date"
    t.string "label"
    t.decimal "total_excluding_taxes"
    t.decimal "vat_amount"
    t.decimal "total_including_taxes"
    t.decimal "advance"
    t.decimal "balance"
    t.integer "unique_index"
    t.boolean "paid"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tracking_id"
    t.decimal "commercial_discount"
    t.text "comments"
    t.string "pdf_file"
    t.index ["customer_id"], name: "index_dorsale_billing_machine_invoices_on_customer_id"
    t.index ["customer_type"], name: "index_dorsale_billing_machine_invoices_on_customer_type"
    t.index ["payment_term_id"], name: "index_dorsale_billing_machine_invoices_on_payment_term_id"
    t.index ["tracking_id"], name: "index_dorsale_billing_machine_invoices_on_tracking_id"
    t.index ["unique_index"], name: "index_dorsale_billing_machine_invoices_on_unique_index", unique: true
  end

  create_table "dorsale_billing_machine_payment_terms", id: :serial, force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_billing_machine_quotation_lines", id: :serial, force: :cascade do |t|
    t.integer "quotation_id"
    t.text "label"
    t.decimal "quantity"
    t.string "unit"
    t.decimal "unit_price"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat_rate"
    t.integer "position", default: 0, null: false
    t.index ["quotation_id"], name: "index_dorsale_billing_machine_quotation_lines_on_quotation_id"
  end

  create_table "dorsale_billing_machine_quotations", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.string "customer_type"
    t.integer "payment_term_id"
    t.date "date"
    t.string "label"
    t.decimal "total_excluding_taxes"
    t.decimal "vat_amount"
    t.decimal "total_including_taxes"
    t.integer "unique_index"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expires_at"
    t.string "tracking_id"
    t.decimal "commercial_discount"
    t.string "state"
    t.string "pdf_file"
    t.index ["customer_id"], name: "index_dorsale_billing_machine_quotations_on_customer_id"
    t.index ["customer_type"], name: "index_dorsale_billing_machine_quotations_on_customer_type"
    t.index ["payment_term_id"], name: "index_dorsale_billing_machine_quotations_on_payment_term_id"
    t.index ["tracking_id"], name: "index_dorsale_billing_machine_quotations_on_tracking_id"
    t.index ["unique_index"], name: "index_dorsale_billing_machine_quotations_on_unique_index", unique: true
  end

  create_table "dorsale_comments", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.string "user_type"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.string "title"
    t.index ["author_id"], name: "index_dorsale_comments_on_author_id"
    t.index ["commentable_id"], name: "index_dorsale_comments_on_commentable_id"
    t.index ["commentable_type"], name: "index_dorsale_comments_on_commentable_type"
    t.index ["user_type"], name: "index_dorsale_comments_on_user_type"
  end

  create_table "dorsale_customer_vault_activity_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_customer_vault_corporations_bak", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "email"
    t.string "phone"
    t.string "fax"
    t.text "www"
    t.string "legal_form"
    t.integer "capital"
    t.string "immatriculation_number_1"
    t.string "immatriculation_number_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "european_union_vat_number"
  end

  create_table "dorsale_customer_vault_events", id: :serial, force: :cascade do |t|
    t.integer "author_id"
    t.integer "person_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "text"
    t.string "title"
    t.date "date"
    t.string "contact_type"
  end

  create_table "dorsale_customer_vault_individuals_bak", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "short_name"
    t.text "email"
    t.string "title"
    t.string "twitter"
    t.text "www"
    t.text "context"
    t.string "phone"
    t.string "fax"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "skype"
  end

  create_table "dorsale_customer_vault_links", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "alice_id"
    t.string "alice_type_bak"
    t.integer "bob_id"
    t.string "bob_type_bak"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alice_id"], name: "index_dorsale_customer_vault_links_on_alice_id"
    t.index ["bob_id"], name: "index_dorsale_customer_vault_links_on_bob_id"
  end

  create_table "dorsale_customer_vault_origins", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_customer_vault_people", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "old_id"
    t.string "first_name"
    t.string "last_name"
    t.string "corporation_name"
    t.string "short_name"
    t.string "avatar"
    t.string "email"
    t.string "phone"
    t.string "mobile"
    t.string "fax"
    t.string "skype"
    t.text "www"
    t.text "twitter"
    t.text "facebook"
    t.text "linkedin"
    t.text "viadeo"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "context"
    t.integer "corporation_id"
    t.integer "activity_type_id"
    t.integer "origin_id"
    t.string "secondary_emails", default: [], null: false, array: true
    t.index ["old_id"], name: "index_dorsale_customer_vault_people_on_old_id"
    t.index ["secondary_emails"], name: "index_dorsale_customer_vault_people_on_secondary_emails", using: :gin
  end

  create_table "dorsale_expense_gun_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "vat_deductible"
  end

  create_table "dorsale_expense_gun_expense_lines", id: :serial, force: :cascade do |t|
    t.integer "expense_id"
    t.integer "category_id"
    t.string "name"
    t.date "date"
    t.float "total_all_taxes"
    t.float "vat"
    t.float "company_part"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_dorsale_expense_gun_expense_lines_on_category_id"
    t.index ["expense_id"], name: "index_dorsale_expense_gun_expense_lines_on_expense_id"
  end

  create_table "dorsale_expense_gun_expenses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_dorsale_expense_gun_expenses_on_user_id"
  end

  create_table "dorsale_flyboy_task_comments", id: :serial, force: :cascade do |t|
    t.integer "task_id"
    t.datetime "date"
    t.text "description"
    t.integer "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.index ["author_id"], name: "index_dorsale_flyboy_task_comments_on_author_id"
    t.index ["task_id"], name: "index_dorsale_flyboy_task_comments_on_task_id"
  end

  create_table "dorsale_flyboy_tasks", id: :serial, force: :cascade do |t|
    t.integer "taskable_id"
    t.string "taskable_type"
    t.string "name"
    t.text "description"
    t.integer "progress"
    t.boolean "done"
    t.date "term"
    t.date "reminder_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "reminder_type"
    t.integer "reminder_duration"
    t.string "reminder_unit"
    t.index ["owner_id"], name: "index_dorsale_flyboy_tasks_on_owner_id"
    t.index ["taskable_id"], name: "index_dorsale_flyboy_tasks_on_taskable_id"
    t.index ["taskable_type"], name: "index_dorsale_flyboy_tasks_on_taskable_type"
  end

  create_table "dummy_models", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "string_field"
    t.text "text_field"
    t.integer "integer_field"
    t.decimal "decimal_field"
    t.date "date_field"
    t.datetime "datetime_field"
    t.boolean "boolean_field"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.boolean "is_active"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
