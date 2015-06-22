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

ActiveRecord::Schema.define(version: 20150619082813) do

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
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.string   "tracking"
    t.integer  "version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "progress"
    t.integer  "folderable_id"
    t.string   "folderable_type"
  end

  create_table "dorsale_flyboy_task_comments", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "date"
    t.text     "description"
    t.integer  "progress"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dorsale_flyboy_tasks", force: :cascade do |t|
    t.integer  "taskable_id"
    t.string   "name"
    t.text     "description"
    t.integer  "progress",      default: 0
    t.boolean  "done"
    t.date     "term"
    t.date     "reminder"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "taskable_type"
  end

  create_table "dummy_models", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
