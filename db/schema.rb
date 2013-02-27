# -*- encoding : utf-8 -*-
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130218085226) do

  create_table "staff_photos", :force => true do |t|
    t.binary   "file",           :limit => 16777215
    t.string   "file_name"
    t.string   "content_type"
    t.integer  "file_size"
    t.string   "staff_workno"
    t.integer  "weixin_user_id"
    t.integer  "status"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "staffs", :force => true do |t|
    t.string   "name"
    t.string   "workno"
    t.string   "phone"
    t.string   "email"
    t.string   "dept"
    t.string   "duty"
    t.string   "username"
    t.string   "pinyin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "weixin_users", :force => true do |t|
    t.string   "weixin_id"
    t.string   "nick"
    t.string   "remark"
    t.integer  "status"
    t.integer  "query_count"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "tmp_photo_id"
  end

end
