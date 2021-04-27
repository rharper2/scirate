require 'nokogiri'
require 'open-uri'


namespace :scirate do
  desc "Scrapes ratings from scirate into our own fabulous feed"
  task new_import: :environment do
    puts "#{Time.now}"
    doc = Nokogiri::HTML(open("https://scirate.com?range=2"))
    theScites = doc.css('div.scites-count a').map { |link| [link.text.strip, link["href"].match('arxiv/(.*)/scites')[1]]}
    theScites.each do |aScite|
	     tp = Paper.find_by uid: aScite[1]
	     if !tp.nil?
		    puts "Will set #{tp.title} to have #{aScite[0]} scites"
                tp.scirate_rates = aScite[0]
		    tp.save!
	    else
		      puts "Couldn't find #{aScite[1]}"
      end
    end
  end
end
