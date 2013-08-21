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
                   2 => ["company_profile"]
              
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
         header_hash = {

        1 => ["logo"],
        2 => ["header_background"],
        3 => ["header_title"] 
    }
    header_hash.each do |key,array|
    	header.create!(logo: array[0],
    		header_background: array[1],
    		header_title: array[2],
    		)
    end

    slider_hash = {
    	1 => ["image"],
    	2 => ["background_image"],
    	3 => ["header"],
    	4 => ["body_tag"]

    }
     slider_hash.each do |key,array|
     	slider.create!(image: array[0],
     	   slider.background_image: array[1],
     	   slider.header: array[2];
     	   slider.body_tag: array[3],
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
			start_date: '2013-08-03' ,
			end_date: '2013-12-03',
			isconcluded: 'f',
			)
			end

			@courses=Course.all
			course_price_hash={
				1=>[@courses[0].id,"10000","2013-08-01","2014-08-31"],
				2=>[@courses[1].id,"10000","2013-08-01","2014-08-31"],
				3=>[@courses[2].id,"10000","2013-08-01","2014-08-31"],
			}
			course_price_hash.each do |key,array|
				CoursePricing.create!(course_id:array[0],
					price:array[1],
					start_date:array[2],
					end_date:array[3])
			end

			TaxRate.create!(valid_from:"2013-08-01", valid_until:"2050-08-31",factor:0.0, is_default: true, description: "Service Tax")
			Coupon.create!(course: "Algorithm Using Program", alpha_code: "AA-BB-CC", digit_mask: "11-22-33",  )
	end
end