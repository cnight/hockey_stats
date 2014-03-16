#!/usr/bin/env ruby

require 'net/http'

class CSVTable
	def initialize(cols)
		@cols = cols
		@rows = []
	end
	
	def <<(row)
		@rows << row.map { |cell| cell.include?(',') ? "\"#{cell.strip}\"" : cell.dup }
	end
	
	def to_csv
		str = @cols.join(',') + "\n"
		str << @rows.map { |row| row.join(',')}.join("\n")
		return str
	end
end

base_uri = "http://ca.sports.yahoo.com/nhl/stats/byposition?pos=C%2CRW%2CLW%2CD&sort=14&conference=NHL&year="
seasons = 1979..2012
sub_seasons = %w(season_ postseason_)

data = nil
seasons.each do |s|
	sea = "#{s}#{s+1}"
	sub_seasons.each do |ss|
		sub = sub_seasons.index(ss) + 2
		puts "#{sea}-#{sub}"
		
		uri = URI(base_uri + ss + s.to_s)
		i = 0
		Net::HTTP.start(uri.host, uri.port) do |conn|
			req = Net::HTTP::Get.new(uri)
			resp = conn.request(req)
			body = resp.body

			if md = /\<tr.+class="ysptblthbody1"[^\>]*\>/.match(body)
				body = md.post_match

				if md = /\<\/table/.match(body)
					body = md.pre_match.gsub("\n", '').gsub(/\<td[^\>]*\>\&nbsp;\<\/td\>/, '').gsub(/\<tr[^\>]*\>/, '').split('</tr>')
					head = body.shift.strip

					#  read table col headers and create CSV table object
					cols = []
					head.split('</td>').each do |h|
						#if md = /\<s?p?an?[^\>]*\>([^\<]+)\<\/s?p?an?\>$/.match(h)
						if md = /.+\>([^\<]+)\<\/[^\>]*\>$/.match(h)
							cols << md[1].strip
						else
							cols << ''
						end
					end
					cols << 'yahoo_player_id'
					data = CSVTable.new(cols)
					
					# read a table row and capture cells
					body.each do |r|
						ypid = 0
						row = []
						r.strip.gsub(/\s*\<td[^\>]*\>/, '').split('</td>').each do |d|
							if md = /^([-\d\.]+)$/.match(d)
								row << md[1].strip
							elsif md = /\<([^\>]*)\>([^\<]+)\<\/[^\>]*\>/.match(d)
								row << md[2].strip
								if md[1] && pmd = /players\/(\d+)/.match(md[1])
									ypid = pmd[1]
								end
							end
						end
						data << row.push(ypid)
					end

					# convert data to csv and write to file
					File.open("data/#{sea}-#{sub}.csv", 'w') << data.to_csv
				end
			end
		end
	end
end