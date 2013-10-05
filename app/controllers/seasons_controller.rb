class SeasonsController < ApplicationController
	
	respond_to :json
	
	def index
		respond_with(Season.order('year, subseason_id').all.as_json(only: ['id', 'current', 'subseason_id'], methods: :name))
	end
end
