class Season < ActiveRecord::Base
	SUBSEASON_NAMES = ['', 'Pre Season', 'Regular Season', 'Playoffs']

	has_many :player_seasons

	def subseason
		SUBSEASON_NAMES[self.subseason_id]
	end

	def name
		@name ||= self.year.to_s.insert(4, '-') + ' ' + self.subseason
	end
	
	def player_season(plyr)
		self.player_seasons.where(:player_id => plyr.id).first
	end
end
