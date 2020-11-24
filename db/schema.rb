# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_24_044926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_items", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "board_id"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "times_moved", default: 0, null: false
    t.bigint "assignee_id"
    t.index ["assignee_id"], name: "index_action_items_on_assignee_id"
    t.index ["board_id"], name: "index_action_items_on_board_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "previous_board_id"
    t.string "slug", null: false
    t.boolean "private", default: false
    t.text "column_names", default: ["mad", "sad", "glad"], array: true
    t.integer "users_count", default: 0
    t.index ["previous_board_id"], name: "index_boards_on_previous_board_id", unique: true
    t.index ["slug"], name: "index_boards_on_slug", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.string "kind", null: false
    t.text "body", null: false
    t.bigint "author_id"
    t.bigint "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes", default: 0
    t.index ["author_id"], name: "index_cards_on_author_id"
    t.index ["board_id"], name: "index_cards_on_board_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "card_id", null: false
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "likes", default: 0
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["card_id"], name: "index_comments_on_card_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "board_id"
    t.string "role"
    t.boolean "ready", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_memberships_on_board_id"
    t.index ["user_id", "board_id"], name: "index_memberships_on_user_id_and_board_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_teams_on_lowercase_name", unique: true
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.index ["team_id", "user_id"], name: "index_teams_users_on_team_id_and_user_id"
    t.index ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "avatar"
    t.string "first_name"
    t.string "last_name"
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "action_items", "boards"
  add_foreign_key "action_items", "users", column: "assignee_id"
  add_foreign_key "boards", "boards", column: "previous_board_id"
  add_foreign_key "cards", "boards"
  add_foreign_key "cards", "users", column: "author_id"
  add_foreign_key "comments", "cards"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "memberships", "boards"
  add_foreign_key "memberships", "users"
  add_foreign_key "teams_users", "teams"
  add_foreign_key "teams_users", "users"
end
