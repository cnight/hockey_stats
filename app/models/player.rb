class Player < ActiveRecord::Base
	has_many :player_seasons
		
	def player_season(ssn)
		self.player_seasons.where(:season_id => ssn.id).first
	end
end
