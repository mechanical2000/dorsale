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

ActiveRecord::Schema.define(version: 20150623093218) do

  create_table "customer_vault_corporations", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "www"
    t.string   "legal_form"
    t.integer  "capital"
    t.string   "immatriculation_number_1"
    t.string   "immatriculation_number_2"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "customer_vault_individuals", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "short_name"
    t.string   "email"
    t.string   "title"
    t.string   "twitter"
    t.string   "www"
    t.text     "context"
    t.string   "phone"
    t.string   "fax"
    t.string   "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_vault_links", force: :cascade do |t|
    t.string   "title"
    t.integer  "alice_id"
    t.string   "alice_type"
    t.integer  "bob_id"
    t.string   "bob_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customer_vault_links", ["alice_id"], name: "index_customer_vault_links_on_alice_id"
  add_index "customer_vault_links", ["alice_type"], name: "index_customer_vault_links_on_alice_type"
  add_index "customer_vault_links", ["bob_id"], name: "index_customer_vault_links_on_bob_id"
  add_index "customer_vault_links", ["bob_type"], name: "index_customer_vault_links_on_bob_type"

  create_table "dorsale_addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street_bis"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addressable_id"
    t.string   "addressable_type"
  end

  create_table "dorsale_alexandrie_attachments", force: :cascade do |t|
    t.integer "attachable_id"
    t.string  "attachable_type"
    t.string  "file"
  end

  create_table "dorsale_billing_machine_id_cards", force: :cascade do |t|
    t.string   "id_card_name"
    t.string   "entity_name"
    t.string   "siret"
    t.string   "legal_form"
    t.integer  "capital"
    t.string   "registration_number"
    t.string   "intracommunity_vat"
    t.string   "address1"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "phone"
    t.string   "contact_full_name"
    t.string   "contact_phone"
    t.string   "contact_address_1"
    t.string   "contact_address_2"
    t.string   "contact_zip"
    t.string   "contact_city"
    t.string   "iban"
    t.string   "bic_swift"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "ape_naf"
    t.text     "custom_info_1"
    t.text     "custom_info_2"
    t.text     "custom_info_3"
    t.string   "contact_fax"
    t.string   "contact_email"
    t.string   "logo"
    t.string   "registration_city"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "dorsale_billing_machine_invoice_lines", force: :cascade do |t|
    t.integer  "invoice_id"
    t.text     "label"
    t.decimal  "quantity"
    t.string   "unit"
    t.decimal  "unit_price"
    t.decimal  "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dorsale_billing_machine_invoice_lines", ["invoice_id"], name: "index_dorsale_billing_machine_invoice_lines_on_invoice_id"

  create_table "dorsale_billing_machine_invoices", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "payment_term_id"
    t.integer  "id_card_id"
    t.date     "date"
    t.string   "label"
    t.decimal  "total_duty"
    t.decimal  "vat_amount"
    t.decimal  "total_all_taxes"
    t.decimal  "advance"
    t.decimal  "balance"
    t.integer  "unique_index"
    t.decimal  "vat_rate"
    t.boolean  "paid"
    t.date     "due_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dorsale_billing_machine_invoices", ["customer_id"], name: "index_dorsale_billing_machine_invoices_on_customer_id"
  add_index "dorsale_billing_machine_invoices", ["customer_type"], name: "index_dorsale_billing_machine_invoices_on_customer_type"
  add_index "dorsale_billing_machine_invoices", ["id_card_id"], name: "index_dorsale_billing_machine_invoices_on_id_card_id"
  add_index "dorsale_billing_machine_invoices", ["payment_term_id"], name: "index_dorsale_billing_machine_invoices_on_payment_term_id"

  create_table "dorsale_billing_machine_payment_terms", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_billing_machine_quotation_lines", force: :cascade do |t|
    t.integer  "quotation_id"
    t.text     "label"
    t.decimal  "quantity"
    t.string   "unit"
    t.decimal  "unit_price"
    t.decimal  "total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "dorsale_billing_machine_quotation_lines", ["quotation_id"], name: "index_dorsale_billing_machine_quotation_lines_on_quotation_id"

  create_table "dorsale_billing_machine_quotations", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "id_card_id"
    t.integer  "payment_term_id"
    t.date     "date"
    t.string   "label"
    t.decimal  "total_duty"
    t.decimal  "vat_amount"
    t.decimal  "total_all_taxes"
    t.integer  "unique_index"
    t.decimal  "vat_rate"
    t.text     "comments"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dorsale_billing_machine_quotations", ["customer_id"], name: "index_dorsale_billing_machine_quotations_on_customer_id"
  add_index "dorsale_billing_machine_quotations", ["customer_type"], name: "index_dorsale_billing_machine_quotations_on_customer_type"
  add_index "dorsale_billing_machine_quotations", ["id_card_id"], name: "index_dorsale_billing_machine_quotations_on_id_card_id"
  add_index "dorsale_billing_machine_quotations", ["payment_term_id"], name: "index_dorsale_billing_machine_quotations_on_payment_term_id"

  create_table "dorsale_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_type"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "dorsale_flyboy_folders", force: :cascade do |t|
    t.integer  "folderable_id"
    t.string   "folderable_type"
    t.string   "name"
    t.text     "description"
    t.integer  "progress"
    t.string   "status"
    t.string   "tracking"
    t.integer  "version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "dorsale_flyboy_folders", ["folderable_id"], name: "index_dorsale_flyboy_folders_on_folderable_id"
  add_index "dorsale_flyboy_folders", ["folderable_type"], name: "index_dorsale_flyboy_folders_on_folderable_type"

  create_table "dorsale_flyboy_task_comments", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "date"
    t.text     "description"
    t.integer  "progress"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dorsale_flyboy_task_comments", ["task_id"], name: "index_dorsale_flyboy_task_comments_on_task_id"

  create_table "dorsale_flyboy_tasks", force: :cascade do |t|
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.string   "name"
    t.text     "description"
    t.integer  "progress"
    t.boolean  "done"
    t.date     "term"
    t.date     "reminder"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "dorsale_flyboy_tasks", ["taskable_id"], name: "index_dorsale_flyboy_tasks_on_taskable_id"
  add_index "dorsale_flyboy_tasks", ["taskable_type"], name: "index_dorsale_flyboy_tasks_on_taskable_type"

  create_table "dummy_models", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
