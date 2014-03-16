#!/usr/bin/env ruby

require '../../../config/environment'
require 'csv'

stat_map = {:teams => 'team', :games_played => 'gp', :goals => 'g', :assists => 'a', :plus_minus => '+/-', :penalty_min => 'pim', :pp_goals => 'pp', :sh_goals => 'sh', :gw_goals => 'gw', :shots => 'shots'} 
type_map = {:teams => :to_s, :games_played => :to_i, :goals => :to_i, :assists => :to_i, :plus_minus => :to_i, :penalty_min => :to_i, :pp_goals => :to_i, :sh_goals => :to_i, :gw_goals => :to_i, :shots => :to_i } 

fnames = ARGV
fnames.each do |fname|
	md = /.*(\d\d\d\d\d\d\d\d)\-(\d)\.csv/.match (fname)
	year = md[1]; sub = md[2]
	puts year + ' ' + sub
	s = Season.where(:year => year).where(:subseason_id => sub).first || Season.create(:year => year, :subseason_id => sub)

	csv = CSV.table(fname, :header_converters => :downcase)
	csv.each do |row|
		p = Player.where(:nhl_player_id => row['nhl_player_id']).first || Player.create(:name => row['player'], :positions => row['pos'], :goalie => (row['pos'].strip.upcase == 'G' ? true : false), :nhl_player_id => row['nhl_player_id'])
		ps = p.player_season(s) || p.player_seasons.build(:season_id => s.id)
		stat_map.each { |k,v| ps[k] = row[v].send(type_map[k]) }
		ps.save
	end

end