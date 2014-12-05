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
  	alta_angie_barb2_bea12_chuck = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=alta&series=angie&series=b2&series=bea1&series=bea2&series=chuck&min=25&max=300&n=2500')
  	blind_david_dorothea_lawrence_merri = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=blind-f&series=blind-m&series=david&series=dorothea&series=lawrence&series=merri&min=25&max=300&n=2500')
  	peruvian_physiologist_bosnak_toby_tom = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=peru-m&series=peru-f&series=physiologist&series=bosnak&series=toby&series=tom&min=50&max=300&n=1000')
  	# blind_david_dorothea_lawrence_merri = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=peru-m&series=peru-f&series=physiologist&series=bosnak&series=toby&series=tom&min=50&max=300&n=1000')




end