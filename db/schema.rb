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

ActiveRecord::Schema.define(version: 20130414064248) do

  create_table "player_seasons", force: true do |t|
    t.integer  "player_id",    default: 0
    t.integer  "season_id",    default: 0
    t.string   "teams",        default: ""
    t.integer  "games_played", default: 0
    t.integer  "goals",        default: 0
    t.integer  "assists",      default: 0
    t.integer  "plus_minus",   default: 0
    t.integer  "shots",        default: 0
    t.float    "shooting_pct", default: 0.0
    t.integer  "penalty_min",  default: 0
    t.integer  "pp_goals",     default: 0
    t.integer  "sh_goals",     default: 0
    t.integer  "gw_goals",     default: 0
    t.float    "avg_toi",      default: 0.0
    t.float    "faceoff_pct",  default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name",          default: ""
    t.string   "team",          default: ""
    t.string   "positions",     default: ""
    t.boolean  "goalie",        default: false
    t.integer  "nhl_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.integer  "year",         default: 0
    t.integer  "subseason_id", default: 0
    t.boolean  "current",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
