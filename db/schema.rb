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

ActiveRecord::Schema.define(version: 20171006124656) do

  create_table "availabilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "semester_id"
    t.integer  "user_id"
    t.integer  "preference_first"
    t.integer  "preference_second"
    t.integer  "preference_third"
    t.string   "comments"
    t.string   "general_comments"
    t.boolean  "researcher"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["semester_id"], name: "index_availabilities_on_semester_id", using: :btree
    t.index ["user_id"], name: "index_availabilities_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fichas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status",                            default: 0
    t.text     "program",             limit: 65535
    t.text     "didactic_procedures", limit: 65535
    t.text     "evaluation",          limit: 65535
    t.text     "general_objective",   limit: 65535
    t.text     "specific_objective",  limit: 65535
    t.text     "basic_bibliography",  limit: 65535
    t.text     "bibliography",        limit: 65535
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["group_id"], name: "index_fichas_on_group_id", using: :btree
    t.index ["user_id"], name: "index_fichas_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "matter_id"
    t.integer  "semester_id"
    t.integer  "option_id"
    t.integer  "unite_group_id"
    t.integer  "course_id"
    t.string   "vacancies"
    t.string   "class_room"
    t.boolean  "active"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["course_id"], name: "index_groups_on_course_id", using: :btree
    t.index ["matter_id"], name: "index_groups_on_matter_id", using: :btree
    t.index ["option_id"], name: "index_groups_on_option_id", using: :btree
    t.index ["semester_id"], name: "index_groups_on_semester_id", using: :btree
    t.index ["unite_group_id"], name: "index_groups_on_unite_group_id", using: :btree
  end

  create_table "groups_schedules", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "group_id"
    t.integer "schedule_id"
    t.index ["group_id"], name: "index_groups_schedules_on_group_id", using: :btree
    t.index ["schedule_id"], name: "index_groups_schedules_on_schedule_id", using: :btree
  end

  create_table "matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "unite_matter_id"
    t.boolean  "actived",                          default: true,     null: false
    t.string   "name"
    t.string   "code"
    t.string   "kind"
    t.string   "prerequisite",                     default: "Nenhum"
    t.string   "corequisite",                      default: "Nenhum"
    t.string   "modality"
    t.string   "nature"
    t.text     "menu",               limit: 65535
    t.text     "basic_bibliography", limit: 65535
    t.text     "bibliography",       limit: 65535
    t.integer  "annual_workload",                  default: 0
    t.integer  "semester_workload",                default: 0
    t.integer  "modular_workload",                 default: 0
    t.integer  "weekly_workload",                  default: 0
    t.integer  "pd",                               default: 0
    t.integer  "lc",                               default: 0
    t.integer  "cp",                               default: 0
    t.integer  "es",                               default: 0
    t.integer  "or",                               default: 0
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["unite_matter_id"], name: "index_matters_on_unite_matter_id", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "message",    limit: 65535
    t.integer  "user_id"
    t.integer  "ficha_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["ficha_id"], name: "index_messages_on_ficha_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "semester_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["semester_id"], name: "index_options_on_semester_id", using: :btree
  end

  create_table "options_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "option_id"
    t.index ["option_id"], name: "index_options_users_on_option_id", using: :btree
    t.index ["user_id"], name: "index_options_users_on_user_id", using: :btree
  end

  create_table "perform_backups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "days"
    t.time     "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time    "begin"
    t.time    "duration"
    t.integer "day"
  end

  create_table "semesters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "year"
    t.integer  "semester"
    t.boolean  "options_selection", default: false, null: false
    t.boolean  "options_generated", default: false, null: false
    t.boolean  "options_finished",  default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "unavailabilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "availability_id"
    t.integer  "schedule_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["availability_id"], name: "index_unavailabilities_on_availability_id", using: :btree
    t.index ["schedule_id"], name: "index_unavailabilities_on_schedule_id", using: :btree
  end

  create_table "unite_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "matter_id"
    t.integer  "semester_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["matter_id"], name: "index_unite_groups_on_matter_id", using: :btree
    t.index ["semester_id"], name: "index_unite_groups_on_semester_id", using: :btree
  end

  create_table "unite_matters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "semester_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["semester_id"], name: "index_unite_matters_on_semester_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "phone"
    t.string   "email",                                 null: false
    t.string   "encrypted_password",                    null: false
    t.string   "name",                                  null: false
    t.boolean  "actived",                default: true, null: false
    t.string   "shortname"
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  create_table "wishes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "option_id"
    t.integer  "user_id"
    t.integer  "semester_id"
    t.integer  "priority"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["option_id"], name: "index_wishes_on_option_id", using: :btree
    t.index ["semester_id"], name: "index_wishes_on_semester_id", using: :btree
    t.index ["user_id"], name: "index_wishes_on_user_id", using: :btree
  end

  add_foreign_key "availabilities", "semesters"
  add_foreign_key "availabilities", "users"
  add_foreign_key "fichas", "groups"
  add_foreign_key "fichas", "users"
  add_foreign_key "groups", "courses"
  add_foreign_key "groups", "matters"
  add_foreign_key "groups", "options"
  add_foreign_key "groups", "semesters"
  add_foreign_key "groups", "unite_groups"
  add_foreign_key "groups_schedules", "groups"
  add_foreign_key "groups_schedules", "schedules"
  add_foreign_key "matters", "unite_matters"
  add_foreign_key "messages", "fichas"
  add_foreign_key "messages", "users"
  add_foreign_key "options", "semesters"
  add_foreign_key "options_users", "options"
  add_foreign_key "options_users", "users"
  add_foreign_key "unavailabilities", "availabilities"
  add_foreign_key "unavailabilities", "schedules"
  add_foreign_key "unite_groups", "matters"
  add_foreign_key "unite_groups", "semesters"
  add_foreign_key "unite_matters", "semesters"
  add_foreign_key "wishes", "options"
  add_foreign_key "wishes", "semesters"
  add_foreign_key "wishes", "users"
end
