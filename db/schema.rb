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

ActiveRecord::Schema.define(version: 20151105212809) do

  create_table "document_versions", force: :cascade do |t|
    t.integer  "uploader_id"
    t.string   "uploader_account_type"
    t.string   "version"
    t.integer  "document_id"
    t.string   "s3_link"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "document_versions", ["document_id"], name: "index_document_versions_on_document_id"
  add_index "document_versions", ["uploader_id"], name: "index_document_versions_on_uploader_id"

  create_table "documents", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "title",              null: false
    t.string   "original_file_name", null: false
    t.string   "status",             null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "documents", ["owner_id"], name: "index_documents_on_owner_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "account_type",                        null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
