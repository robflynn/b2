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

ActiveRecord::Schema.define(version: 2019_04_18_140429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "page_filters", force: :cascade do |t|
    t.bigint "website_id"
    t.string "filter", null: false
    t.string "filter_type", default: "regex"
    t.string "note"
    t.index ["website_id", "filter_type"], name: "index_page_filters_on_website_id_and_filter_type"
    t.index ["website_id"], name: "index_page_filters_on_website_id"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "website_id"
    t.string "url", limit: 4096
    t.string "title", limit: 1024
    t.string "content_type"
    t.text "content"
    t.integer "response_code"
    t.string "referrer", limit: 4096
    t.integer "status", default: 0
    t.datetime "visited_at"
    t.string "message"
    t.string "digest", limit: 64
    t.index ["digest"], name: "index_pages_on_digest"
    t.index ["website_id", "status"], name: "index_pages_on_website_id_and_status"
  end

  create_table "websites", force: :cascade do |t|
    t.string "domain"
    t.string "name", null: false
    t.string "url", null: false
    t.integer "status", default: 0
    t.datetime "crawled_at"
    t.datetime "processed_at"
    t.index ["status"], name: "index_websites_on_status"
  end

end
