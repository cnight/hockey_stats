class CreatePlayerSeasons < ActiveRecord::Migration
  def change
    create_table :player_seasons do |t|
      t.integer :player_id, :default => 0
      t.integer :season_id, :default => 0
      t.string :teams, :default => ''
      t.integer :games_played, :default => 0
      t.integer :goals, :default => 0
      t.integer :assists, :default => 0
      t.integer :plus_minus, :default => 0
      t.integer :shots, :default => 0
      t.float :shooting_pct, :default => 0.0
      t.integer :penalty_min, :default => 0
      t.integer :pp_goals, :default => 0
      t.integer :sh_goals, :default => 0
      t.integer :gw_goals, :default => 0
      t.float :avg_toi, :default => 0.0
      t.float :faceoff_pct, :default => 0.0

      t.timestamps
    end
  end
end
