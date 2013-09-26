class PlayerSeasonsController < ApplicationController
	
	respond_to :json

	def index
		if params[:player_id]
			player = Player.find(params[:player_id])
			respond_with(player.player_seasons.as_json(except: ['created_at', 'updated_at'], methods: :points))
		end
	end
end
