# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_15_092504) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "report_mail_projects", force: :cascade do |t|
    t.bigint "report_mail_id", null: false
    t.string "name", null: false
    t.string "features_ready_title"
    t.text "features_ready"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "to"
    t.text "server_urls"
    t.index ["report_mail_id"], name: "index_report_mail_projects_on_report_mail_id"
  end

  create_table "report_mail_tasks", force: :cascade do |t|
    t.bigint "report_mail_project_id", null: false
    t.string "issue_number"
    t.text "description", null: false
    t.string "progress_status"
    t.string "deploy_status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 10, null: false
    t.decimal "weight_percentage", precision: 6, scale: 3
    t.string "category", limit: 10
    t.index ["report_mail_project_id"], name: "index_report_mail_tasks_on_report_mail_project_id"
  end

  create_table "report_mails", force: :cascade do |t|
    t.date "date"
    t.string "to"
    t.string "subject"
    t.string "template"
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cc"
    t.text "signature"
    t.string "message_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name"
  end

  add_foreign_key "report_mail_projects", "report_mails"
  add_foreign_key "report_mail_tasks", "report_mail_projects"
end
