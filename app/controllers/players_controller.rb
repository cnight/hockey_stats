class PlayersController < ApplicationController
	
	respond_to :json
	
	def root
	end
	
	def index
		respond_with(Player.order('name').all.as_json(only: ['id', 'name', 'positions']))
	end
end
