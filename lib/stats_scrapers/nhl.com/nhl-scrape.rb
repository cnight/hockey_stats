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

base_uri = "http://www.nhl.com/ice/historicalstats.htm?season=<SEA>&gameType=<SUB>"
#seasons = %w(19791980 19801981 19811982 19821983 19831984 19841985 19851986 19861987 19871988 19881989 19891990)
#seasons = %w(19901991 19911992 19921993 19931994 19941995 19951996 19961997 19971998 19981999 19992000 20002001)
#seasons = %w(20012002 20022003 20032004 20052006 20062007 20072008 20082009 20092010 20102011 20112012 20122013)
sub_seasons = %w(2 3)

data = nil
seasons.each do |s|
	sub_seasons.each do |ss|
		puts "#{s}-#{ss}"
		uri = URI(base_uri.sub('<SEA>', s).sub('<SUB>', ss))
		i = 0
		Net::HTTP.start(uri.host, uri.port) do |conn|
			req = Net::HTTP::Get.new(uri)
			resp = conn.request(req)
			body = resp.body

			if md = /\<table.+class="data stats"[^\>]*\>/.match(body)
				body = md.post_match

				if md = /\<\/table/.match(body)
					body = md.pre_match
					_, body = body.split('<thead>')
					head, body = body.split('</thead>')
					foot, body = body.split('</tfoot>')
					body, _ = body.split('</tbody>')

					#  read table col headers and create CSV table object; only if this is the first time through the loop
					unless data
						cols = []
						head = head.gsub(/\<(\/)?tr\>/, '')
						head.split('</th>').each do |h|
							if md = /\<th[^\>]*\>(\<a[^\>]*\>)?([^\<]+)(\<)?/.match(h)
								cols << md[2].strip
							else
								cols << ''
							end
						end
						data = CSVTable.new(cols.push('nhl_player_id'))
					end

					# read a table row and capture cells
					body.split('</tr>').each do |r|
						row = []
						pid = '!!notfound!!'
						r.split('</td>').each do |d|
							if md = /\<td[^\>]*\>(\<a[^\>]*\>)?([^\<]+)(\<)?/.match(d)
								row << md[2].strip
								if pmd = /player\.htm\?id=(\d+)/.match(md[0])
									pid = pmd[1]
								end
							else
								row << ''
							end
						end
						data << row.push(pid)
					end

					# if more pages, go to next page and re-run
					if nxt = /\<a\s.*href="([^"]+)"[^\>]*>Next\<\/a\>/.match(foot)
						p, q = nxt[1].split('?')
						uri.path = p
						uri.query = q.gsub('&amp;','&')
						redo
					end

					# convert data to csv and write to file
					File.open("data/#{s}-#{ss}.csv", 'w') << data.to_csv
					data = nil
				end
			end
		end
	end
end