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

ActiveRecord::Schema.define(version: 20170403124756) do

  create_table "fichas", force: :cascade do |t|
    t.string   "general_objective"
    t.text     "specific_objective",  default: ""
    t.text     "program",             default: ""
    t.text     "didactic_procedures", default: ""
    t.text     "evaluation",          default: ""
    t.text     "basic_bibliography",  default: ""
    t.text     "bibliography",        default: ""
    t.string   "status",              default: "Enviado"
    t.text     "appraisal",           default: ""
    t.integer  "user_id"
    t.integer  "matter_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["matter_id"], name: "index_fichas_on_matter_id"
    t.index ["user_id"], name: "index_fichas_on_user_id"
  end

  create_table "matters", force: :cascade do |t|
    t.string   "name"
    t.boolean  "actived",                default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "code"
    t.string   "kind"
    t.string   "prerequisite"
    t.string   "corequisite"
    t.string   "modality"
    t.string   "nature"
    t.string   "menu",                   default: ""
    t.integer  "total_annual_workload",  default: 0
    t.integer  "total_weekly_workload",  default: 0
    t.integer  "total_modular_workload", default: 0
    t.integer  "weekly_workload",        default: 0
    t.integer  "pd",                     default: 0
    t.integer  "lc",                     default: 0
    t.integer  "cp",                     default: 0
    t.integer  "es",                     default: 0
    t.integer  "or",                     default: 0
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "name",                   default: "",   null: false
    t.integer  "role",                   default: 0,    null: false
    t.boolean  "actived",                default: true, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
