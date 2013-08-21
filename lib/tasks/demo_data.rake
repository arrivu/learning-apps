namespace :db do

	task populate: :environment do
		
		topics_hash = {
			1 => ["Algorithm",
				"Category Algorithm"],
				2 => ["Concept of Digital",
					"Category Concept of Digital"],
					3 => ["Engineering",
						"Category Engineering"]
					}

					topics_hash.each do |key, array|
						Topic.create!(
							name: array[0],
							desc: array[1],
							)
					end

         footer_hash = {
                   1 => ["social_links"],
                   2 => ["companyprofile"]
              
               }
               footer_hash.each do |key,array|
               	footer.create!(youtube_url: array[0],
               		linkedin_url: array[0],
               		google_url: array[0],
               		facebook_url: array[0],
               		twitter_url: array[0],
               		about_url: array[1],
               		contactus_url: array[1],
               		privacy_policy_url: array[1], 
               		terms_condition_url: array[1],
                    )
               end

        
		courses_hash = {
			1 => ["Algorithm Using Program", 
			 	"Learn Algorithm using the language of Program",1
			 	],
			2 => ["SOCIAL MEDIA", 
			 	"Learn web applications and create new social media",1
			 	],
			3 => ["Technology of Networking", 
			 	"Learn Big data send and receive using the language of Networking",1
			 	]
			}

			courses_hash.each do |key, array|
			Course.create!(title: array[0],
			desc: array[1],
			topic_id: array[2],
			short_desc: array[1],
			ispublished: 1 ,
			start_date: '2013-05-03' ,
			end_date: '2013-12-03',
			isconcluded: 'f',
			)
			end

			@courses=Course.all
			course_price_hash={
				1=>[@courses[0].id,"10000","2013-02-01","2014-03-31"],
				2=>[@courses[1].id,"10000","2013-02-01","2014-03-31"],
				3=>[@courses[2].id,"10000","2013-02-01","2014-03-31"],
			}
			course_price_hash.each do |key,array|
				CoursePricing.create!(course_id:array[0],
					price:array[1],
					start_date:array[2],
					end_date:array[3])
			end

			TaxRate.create!(valid_from:"2013-03-01", valid_until:"2050-03-31",factor:0.0, is_default: true, description: "Service Tax")
	end
end