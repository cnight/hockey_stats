class PlayerSeason < ActiveRecord::Base
	belongs_to :player
	belongs_to :season
	
	def points
		return self.goals + self.assists
	end
end
