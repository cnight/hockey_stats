#!/usr/bin/env ruby

#
# NOT READY!
#

require '../../config/environment'
require 'csv'

stat_map = {:teams => 'team', :games_played => 'gp', :goals => 'g', :assists => 'a', :plus_minus => '+/-', :penalty_min => 'pim', :pp_goals => 'ppg', :sh_goals => 'shg', :gw_goals => 'gw', :shots => 'sog', :shooting_pct => 'pct', :faceoff_pct => 'fo%'} 
type_map = {:teams => :to_s, :games_played => :to_i, :goals => :to_i, :assists => :to_i, :plus_minus => :to_i, :penalty_min => :to_i, :pp_goals => :to_i, :sh_goals => :to_i, :gw_goals => :to_i, :shots => :to_i } 


fnames = ARGV
fnames.each do |fname|
	year, sub = fname.split('.')[0].split('-').map { |s| s.to_i }
	s = Season.where(:year => year).where(:subseason_id => sub).first || Season.create(:year => year, :subseason_id => sub)

	csv = CSV.table(fname, :header_converters => :downcase)
	csv.each do |row|
		p = Player.where(:name => row['player']).first || Player.create(:name => row['player'], :positions => row['pos'], :goalie => (row['pos'].strip.upcase == 'G' ? true : false))
		ps = p.player_season(s) || p.player_seasons.build(:season_id => s.id)
		stat_map.each { |k,v| ps[k] = row[v].call(type_map[k]) }
		ps.save
	end

end