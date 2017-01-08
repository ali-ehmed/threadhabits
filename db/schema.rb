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

ActiveRecord::Schema.define(version: 20170108224625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "place_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string   "title"
    t.integer  "listing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_chat_rooms_on_listing_id", using: :btree
  end

  create_table "chatrooms_people", force: :cascade do |t|
    t.integer  "chat_room_id"
    t.integer  "person_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["chat_room_id"], name: "index_chatrooms_people_on_chat_room_id", using: :btree
    t.index ["person_id"], name: "index_chatrooms_people_on_person_id", using: :btree
  end

  create_table "designers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "following_id"
    t.integer  "follower_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "category_id"
    t.integer  "person_id"
    t.float    "price"
    t.string   "condition"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "slug"
    t.integer  "company_id"
    t.integer  "size_id"
    t.integer  "product_type_id"
    t.string   "display_image_file_name"
    t.string   "display_image_content_type"
    t.integer  "display_image_file_size"
    t.datetime "display_image_updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "chat_room_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "body"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "read",         default: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                    default: false
    t.text     "about_you"
    t.string   "phone_number"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "paypal_id"
    t.index ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  end

  create_table "preferences", force: :cascade do |t|
    t.integer  "person_id"
    t.hstore   "data"
    t.string   "preference_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["person_id"], name: "index_preferences_on_person_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sizes", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_type_id"
    t.string   "selection"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "listing_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_foreign_key "chat_rooms", "listings"
  add_foreign_key "chatrooms_people", "chat_rooms"
  add_foreign_key "chatrooms_people", "people"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "preferences", "people"
end
