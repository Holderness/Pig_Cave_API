namespace :db do

	desc "seed database with stories"
	task :sixwordstories => :environment do

		Story.delete_all

		require 'CSV'

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

		require 'CSV'

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

end