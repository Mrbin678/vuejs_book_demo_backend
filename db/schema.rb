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

ActiveRecord::Schema.define(version: 20170731073601) do

  create_table "buy_goods", force: true do |t|
    t.integer  "good_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "category_img"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "avatar"
    t.integer  "open_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_url"
    t.integer  "category_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",       limit: 24
  end

  create_table "goods_photos", force: true do |t|
    t.integer  "good_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: true, comment: "记录日志的表" do |t|
    t.string   "controller",     comment: "rails 控制器"
    t.string   "action",         comment: "rails action"
    t.string   "user_name",      comment: "当前登录用户名"
    t.text     "parameters",     comment: "rails的 params"
    t.datetime "created_at",     comment: "创建时间"
    t.string   "remote_ip",      comment: "远程IP"
    t.string   "restful_method", comment: "get/post/put/delete"
  end

  create_table "orders", force: true do |t|
    t.string   "order_id"
    t.string   "receiver_name"
    t.string   "receiver_address"
    t.string   "receiver_phone"
    t.float    "total_cost",       limit: 24
    t.boolean  "order_status"
    t.string   "guest_remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
