HockeyStats::Application.routes.draw do
	scope format: true, constraints: {format: 'json'} do
		get "players", to: "players#index"
		get "seasons", to: "seasons#index"
		get "players/:player_id/seasons", to: "player_seasons#index", as: 'player_seasons'
	end	
	root to: "players#root"
end
