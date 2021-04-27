namespace :db do
  desc "Fix up erroneous pubdates papers"
  task sortpub_papers: :environment do
    i = 0
    Paper.find_in_batches(batch_size: 10000) do |papers|
       	papers.each do |paper|
 	 	submit = paper.submit_date.in_time_zone('EST')
    		pubdate = paper.pubdate # submit.dup.change(hour: 20)
		#if submit.year==2019 && submit.month == 12 && submit.day == 2 
		#if pubdate.year==2019 && pubdate.month == 12 && pubdate.day == 3
		  puts "Arxiv #{paper.uid} has submit date #{submit} hour of #{submit.hour} and publish date #{paper.pubdate}"
		  pubdate = submit +1.day
		  puts "Its new submit publish date might be #{pubdate}"
		  		#Weekend submissions => Monday
    	  if [6,0].include?(submit.wday)
        		pubdate += 1.days if submit.wday == 0
      			pubdate += 2.days if submit.wday == 6
    	  else
      			if submit.wday == 5
        			pubdate += 2.days # Friday submissions => Sunday
        		end
		  end
		  puts "Its new submit publish date might be #{pubdate}"
		  paper.pubdate = pubdate 
		  paper.save!


	end
  end
end
end
		  #if submit.hour < 17  
					#&& paper.pubdate.year == 2019 && paper.pubdate.month == 8 && paper.pubdate.day == 8 
	#		puts "Arxiv #{paper.uid} has submit date #{submit} and publish date #{paper.pubdate}"
	#	  	pubdate.change(day:  9)
	#	  pubdate = pubdate.utc
		#  pubdate -= 1.day
		#  	puts "New pubdate #{pubdate}"
#		  paper.pubdate = pubdate 
#		  paper.save!
#		  end
	        #end
		#Weekend submissions => Monday
    		#if [6,0].include?(submit.wday)
        	#	pubdate += 1.days if submit.wday == 0
      		#	pubdate += 2.days if submit.wday == 6
    		#else
      		#	if submit.wday == 5
        #			pubdate += 2.days # Friday submissions => Sunday
        #		end
	#	end

        #	if submit.hour >= 16 # Past submission deadline
        #   		pubdate += 1.day
        #	end
	#		puts "Change Arxiv #{paper.uid} from #{submit} /#{paper.pubdate} to #{pubdate.utc}"

	#	if paper.pubdate.utc.wday != pubdate.utc.wday
	#	   puts "Moved #{paper.pubdate}, submit #{submit} to #{pubdate.utc}"
	#	   paper.pubdate = pubdate.utc 
	#	   paper.save!
	#	end
    #  	end
   # end
 # end
#end