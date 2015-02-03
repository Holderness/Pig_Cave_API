namespace :db do

  require 'csv'
  require 'nokogiri'

  desc "seed database with stories"
  task :sixwordstories => :environment do

  Story.delete_all
  conn = PG::Connection.open(:dbname => 'redditation_development')

  CSV.foreach("/Users/frank/src/projects/redditation/sixwordstories.csv", headers: true) do |row|
    if row["score"] && row["title"] && row["author"] && row["permalink"]
      score = row["score"].gsub(/'/, "''")
      title = row["title"].gsub(/'/, "''")
      author = row["author"].gsub(/'/, "''")
      permalink = row["permalink"].gsub(/'/, "''")
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
        score = row["score"].gsub(/'/, "''")
        title = row["title"].gsub(/'/, "''")
        author = row["author"].gsub(/'/, "''")
        permalink = row["permalink"].gsub(/'/, "''")
        puts "INSERT INTO thoughts (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');"
        conn.exec("INSERT INTO thoughts (score, title, author, permalink) VALUES ('#{score}', '#{title}', '#{author}', '#{permalink}');")
      end
    end
    conn.close
  end

  desc "seed database with more thoughts"
  task :showerthoughts2 => :environment do

    scraped_showerthoughts = HTTParty.get('http://www.reddit.com/r/Showerthoughts/top/.json?sort=top&t=year&limit=100')
    sleep 5 ## being polite to reddits's servers
    scraped_showerthoughts1 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2e0o0z')
    sleep 5
    scraped_showerthoughts2 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2nhcmk')
    sleep 5
    scraped_showerthoughts3 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2bye7v')
    sleep 5
    scraped_showerthoughts4 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2j25fq')
    sleep 5
    scraped_showerthoughts5 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_1vh3af')
    sleep 5
    scraped_showerthoughts6 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2aevjl')
    sleep 5
    scraped_showerthoughts7 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2bnptt')
    sleep 5
    scraped_showerthoughts8 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_2fps7b')
    sleep 5
    scraped_showerthoughts9 = HTTParty.get('http://www.reddit.com/r/showerthoughts/top/.json?sort=top&t=year&limit=100&after=t3_1xb6wq')
    sleep 5

    def reduce_api_data(data)
      data["data"]["children"].map do |thought| 
        {
        "score" => thought["data"]["score"], 
        "title" => thought["data"]["title"], 
        "author" => thought["data"]["author"], 
        "permalink" => thought["data"]["permalink"]
        }
      end
    end

    thought_array = []
    thought_array << reduce_api_data(scraped_showerthoughts)
    thought_array << reduce_api_data(scraped_showerthoughts1)
    thought_array << reduce_api_data(scraped_showerthoughts2)
    thought_array << reduce_api_data(scraped_showerthoughts3)
    thought_array << reduce_api_data(scraped_showerthoughts4)
    thought_array << reduce_api_data(scraped_showerthoughts5)
    thought_array << reduce_api_data(scraped_showerthoughts6)
    thought_array << reduce_api_data(scraped_showerthoughts7)
    thought_array << reduce_api_data(scraped_showerthoughts8)
    thought_array << reduce_api_data(scraped_showerthoughts9)
    thought_array.flatten!

    thought_array.each do |thought_hash|
      Thought.create({ score: thought_hash["score"], title: thought_hash["title"], author: thought_hash["author"], permalink: thought_hash["permalink"]})
    end
  end



  desc "seed database with dreams"
  task :percolate_dreams => :environment do

  	barb_sanders_1 = HTTParty.get('http://www.dreambank.net/random_sample.cgi?series=b&min=25&max=300&n=2500')
  	sleep 30  ## being polite to dreambank's servers
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