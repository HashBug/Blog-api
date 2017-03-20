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

ActiveRecord::Schema.define(version: 20161022050322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "type"
    t.integer  "parent"
    t.integer  "status",     limit: 2, default: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "type"
    t.integer  "parent"
    t.integer  "likes",                default: 0
    t.integer  "dislikes",             default: 0
    t.integer  "status",     limit: 2, default: 1
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.string   "detail"
    t.string   "status",     limit: 1, default: "1"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "images", ["post_id"], name: "index_images_on_post_id", using: :btree
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "post_likes", force: :cascade do |t|
    t.integer  "like",       limit: 2, default: 1
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "post_likes", ["post_id"], name: "index_post_likes_on_post_id", using: :btree
  add_index "post_likes", ["user_id"], name: "index_post_likes_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.text     "content"
    t.integer  "status",         limit: 2, default: 1
    t.integer  "likes_count",              default: 0
    t.integer  "dislikes_count",           default: 0
    t.integer  "comments_count",           default: 0
    t.integer  "top",            limit: 2, default: 0
    t.integer  "flag",                     default: 0
    t.integer  "liked",          limit: 2, default: 0
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "auth_token"
    t.string   "gcm_token"
    t.string   "login_ip"
    t.integer  "status",     default: 1
    t.datetime "expires_at"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "password_digest"
    t.string   "email"
    t.string   "access_token"
    t.string   "fb_uid"
    t.string   "google_uid"
    t.string   "twitter_uid"
    t.string   "li_uid"
    t.string   "image"
    t.string   "dob"
    t.string   "gender"
    t.string   "country"
    t.string   "gplus_link"
    t.string   "fb_link"
    t.string   "twitter_link"
    t.string   "li_link"
    t.string   "website"
    t.string   "verification_code"
    t.string   "refer_code"
    t.string   "timezone"
    t.string   "login_ip"
    t.text     "about"
    t.text     "tagline"
    t.datetime "last_login"
    t.integer  "login_count",                 default: 0
    t.integer  "points"
    t.integer  "email_verified",    limit: 2, default: 0
    t.integer  "referred",          limit: 2, default: 0
    t.integer  "role",              limit: 2, default: 1
    t.integer  "status",            limit: 2, default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "images", "posts"
  add_foreign_key "images", "users"
  add_foreign_key "post_likes", "posts"
  add_foreign_key "post_likes", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users"
  add_foreign_key "sessions", "users"
end
