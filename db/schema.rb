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

ActiveRecord::Schema.define(version: 2018_12_02_054420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "discord_id", null: false
    t.integer "preawakening_attack_power", null: false
    t.integer "awakening_attack_power", null: false
    t.integer "defense_power", null: false
    t.integer "renown_score", null: false
    t.decimal "level", null: false
    t.string "class_name", null: false
    t.string "family_name", null: false
    t.string "character_name", null: false
    t.string "image_url"
    t.boolean "primary", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awakening_attack_power"], name: "index_characters_on_awakening_attack_power"
    t.index ["character_name"], name: "index_characters_on_character_name"
    t.index ["class_name"], name: "index_characters_on_class_name"
    t.index ["defense_power"], name: "index_characters_on_defense_power"
    t.index ["family_name", "character_name", "discord_id"], name: "characters_composite_idx", unique: true
    t.index ["family_name"], name: "index_characters_on_family_name", unique: true
    t.index ["preawakening_attack_power"], name: "index_characters_on_preawakening_attack_power"
    t.index ["renown_score"], name: "index_characters_on_renown_score"
  end

  create_table "users", force: :cascade do |t|
    t.string "discord_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_id"], name: "index_users_on_discord_id", unique: true
  end

end
