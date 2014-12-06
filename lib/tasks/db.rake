namespace :db do

	require 'CSV'
	require 'nokogiri'

	desc "seed database with stories"
	task :sixwordstories => :environment do

		Story.delete_all
		conn = PG::Connection.open(:dbname => 'redditation_development')

		CSV.foreach("/Users/frank/src/projects/redditation/sixwordstories.csv", headers: true) do |row|
			if row["score"] && row["title"] && row["author"] && row["permalink"]
				score = row["score"].delete("'")
				title = row["title"].delete("'")
				author = row["author"].delete("'")
				permalink = row["permalink"].delete("'")
				puts "INSERT INTO stories (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');"
        conn.exec("INSERT INTO stories (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');")
      end
    end
    conn.close
  end


	desc "seed database with thoughts"
	task :showerthoughts => :environment do

		Thought.delete_all
		conn = PG::Connection.open(:dbname => 'redditation_development')

		CSV.foreach("/Users/frank/src/projects/redditation/Showerthoughts.csv", headers: true) do |row|
			if row["score"] && row["title"] && row["author"] && row["permalink"]
				score = row["score"].delete("'")
				title = row["title"].delete("'")
				author = row["author"].delete("'")
				permalink = row["permalink"].delete("'")
				puts "INSERT INTO thoughts (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');"
        conn.exec("INSERT INTO thoughts (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');")
      end
    end
    conn.close
  end

  desc "seed database with dreams"
  task :percolate_dreams => :environment do

  	barb_sanders_1 = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=b&min=25&max=300&n=2500')
  	sleep 30  ## trying to be polite to dreambank's servers
  	alta_angie_barb2_bea12_chuck = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=alta&series=angie&series=b2&series=bea1&series=bea2&series=chuck&min=25&max=300&n=2500')
  	sleep 30
  	blind_david_dorothea_lawrence_merri = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=blind-f&series=blind-m&series=david&series=dorothea&series=lawrence&series=merri&min=25&max=300&n=2500')
  	sleep 30
  	peruvian_physiologist_bosnak_toby_tom = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=peru-m&series=peru-f&series=physiologist&series=bosnak&series=toby&series=tom&min=50&max=300&n=1000')
  	sleep 30
  	arlie_chris_ed_joan_naturalscientist = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=arlie&series=chris&series=ed&series=joan&series=natural_scientist&min=50&max=300&n=1500')


  	def to_arr(dreampage)
  		dream_array = []
  		dreampage_rdom = Nokogiri::HTML(dreampage)
      dreampage_span = dreampage_rdom.css('span')
      dream_arr = dreampage_span.map do |dream|
      	dream.text
      end
      dream_arr.each do |dream|
      	dream.scrub!(".5")
      	dreaming = dream.gsub(/([^.]*)$/, "").gsub(/\A([^)]*)./, "").gsub("\"", "'")
      	if dreaming.include?("[")
      		dreaming.gsub!(/\A([^\]]*)./, "")
      	end
      	dream_array << dreaming
      end
      return dream_array
    end

    dreams = []
    dreams << to_arr(barb_sanders_1)
    dreams << to_arr(alta_angie_barb2_bea12_chuck)
    dreams << to_arr(blind_david_dorothea_lawrence_merri)
    dreams << to_arr(peruvian_physiologist_bosnak_toby_tom)
    dreams << to_arr(arlie_chris_ed_joan_naturalscientist)
    dreams.flatten!

    dreams.each do |dream|
    	Dream.create({ dream: dream })
    end
  end



end