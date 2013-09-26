class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :default => ''
			t.string :team, :default => ''
      t.string :positions, :default => ''
      t.boolean :goalie, :default => false
			t.integer :nhl_player_id

      t.timestamps
    end
  end
end
