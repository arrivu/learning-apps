namespace :db do

	task populate: :environment do
		topics_hash = {
			1 => ["Analytics",
				"Category Analytics",
				1],
				2 => ["Digital Marketing",
					"Category Digital Marketing",
					1,1,1],
					3 => ["Entrepreneurship",
						"Category Entrepreneurship",
						1,2,1]
					}

					topics_hash.each do |key, array|
						Topic.create!(
							name: array[0],
							desc: array[1],
							account_id:  array[2],
							parent_topic_id: array[3],
							root_topic_id: array[4],
							)
					end

		courses_hash = {
			1 => ["Analytics Using SAS", 
			 	"Learn Big data analytics using the language of SAS",3,
			 	1
			 	],
			2 => ["SOCIAL MEDIA MARKETING", 
			 	"Gaining traffic & attention through social media",3,
			 	1
			 	],
			3 => ["FINANCIAL MODELING", 
			 	"Learn Big data analytics using the language of SAS",3,
			 	1
			 	]
			}

			courses_hash.each do |key, array|
			Course.create!(title: array[0],
			desc: array[1],
			topic_id: array[2],
			account_id:  array[3],
			short_desc: array[1],
			is_published: 1 ,
			start_date: '2013-05-03' ,
			end_date: '2013-12-03',
			is_concluded: 'f',
			)
			end

			@courses=Course.all
			course_price_hash={
				1=>[@courses[0].id,"10000","2013-02-01","2014-03-31",1],
				2=>[@courses[1].id,"10000","2013-02-01","2014-03-31",1],
				3=>[@courses[2].id,"10000","2013-02-01","2014-03-31",1],
			}
			course_price_hash.each do |key,array|
				CoursePricing.create!(course_id:array[0],
					price:array[1],
					start_date:array[2],
					end_date:array[3],
					account_id:  array[4],
					
					)
			end

			TaxRate.create!(valid_from:"2013-03-01", valid_until:"2050-03-31",factor:0.0, is_default: true, description: "Service Tax",account_id: 1)
	end
end