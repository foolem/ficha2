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

ActiveRecord::Schema.define(version: 20170314131206) do

  create_table "matters", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "workload"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code"
    t.string   "kind"
    t.string   "prerequisite"
    t.string   "corequisite"
    t.string   "modality"
    t.string   "menu"
    t.integer  "total_annual_workload"
    t.integer  "total_weekly_workload"
    t.integer  "total_modular_workload"
    t.integer  "weekly_workload"
    t.integer  "pd"
    t.integer  "lc"
    t.integer  "cp"
    t.integer  "es"
    t.integer  "or"
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_teachers_on_matter_id"
  end

end
