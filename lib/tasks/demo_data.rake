#encoding: utf-8
namespace :db do
	task demo: :environment do
	account =Account.create! :active => true, :name=>"demo", :no_of_courses=>"0", :no_of_users=>"0", :organization=>"learning Portal"
  puts 'SETTING UP DEFAULT USER LOGIN'
  if Rails.env.development?
     user_account=User.create! :name=> 'Account Admin', :email => 'demo@arrivusystems.com',:password=>'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
  end
  puts 'User created: ' << user_account.name
  @account_user = account.add_user(user_account, 'AccountAdmin')
  user_account.add_role :account_admin

		topics_hash = {
			1 => ["Algorithm",
				"Category Algorithm",2],
				2 => ["Concept of Digital",
					"Category Concept of Digital",2,1,1],
					3 => ["Engineering",
						"Category Engineering",2,2,1]
					}

					topics_hash.each do |key, array|
						Topic.create!(
							name: array[0],
							desc: array[1],
							account_id: array[2],
							parent_topic_id: array[3],
							root_topic_id: array[4]
							)
					end

  AccountSetting.create!(
    knowledge_partners: "TRUE",
    media_partners: "TRUE",
    slide_show: "TRUE",
    popular_speak: "TRUE",
    testimonial: "TRUE",
    account_id: 2)

               	Footerlink.create!(youtube_url: "https://www.youtube.com",
               		linkedin_url: "https://www.linkedin.com",
               		google_url: "https://www.plus.google.com",
               		facebook_url: "https://www.facebook.com",
               		twitter_url: "https://www.twitter.com",
               		
               		 copy_write: "© Beacon Learning",account_id: 2 )
                     
               	HeaderDetail.create!(
                    logo: "viewlogo.png",
                    theme: File.read('public/images/blueheader.jpg'),
                  
                           
                    logo_name: "viewlogo.png",
               		  theme_name: "images.jpg",
        

               		  logo_type: "images/png",
               		  theme_type: "images/jpeg",
               		
                 		message: "Online Learning",
                 		account_id: 2 
                )

               	Slider.create!(
                 		image:File.read('public/images/download.jpg'),
                 		background_image:File.read('public/images/slidereducation.jpg'),
                 		image_name:"download.jpg",
                    background_image_name: "slidereducation.jpg",
                 		image_type: "images/jpeg",
                 		background_image_type: "images/jpeg",
                 		header: "Online Learning",
                 		body_tag: "Learning is a good one for brain",
                 		account_id: 2 
               	)

                Slider.create!(
               		  image:File.read('public/images/stem.jpg'),
               		  background_image:File.read('public/images/slide-edu.jpg'),
               		  image_name:"stem.jpg",
                    background_image_name: "slide-edu.jpg",
               		  image_type: "images/jpeg",
               		  background_image_type: "images/jpeg",
               		  header: "Learning Online",
               		  body_tag: "This is a new way for learning in online  ",
               		  account_id: 2
              	)

                Partner.create!(
                  	company_name:"Runit",
                  	image:File.read('public/images/viewlogo.png'),
                  	image_type:"images/png",
                  	file_name: "viewlogo.png",
                  	comments:"fffffffffffffffff",
    			        	account_id: 2 
                )

                Testimonial.create!(
                  	name:"Test",
                  	organization:"Runit",
                  	job:"tester",
                  	comment:"The Greatest online Learning for only instution in india 
                      and availabe for un limited courses in Beacon online learning",
                  	account_id: 2
			         	)
                Aboutdetail.create!(
                  	title:"Online Learning",
                  	desc: "E-learning refers to the use of electronic media and information 
                  	       and communication technologies (ICT) in education. E-learning is broadly
                           inclusive of all forms of educational technology in learning and teaching. 
                           E-learning is inclusive of, and is broadly synonymous with multimedia learning, 
                           technology-enhanced learning (TEL), computer-based instruction (CBI),
                           computer-based training (CBT), computer-assisted instruction or computer-aided 
                           instruction (CAI), internet-based training (IBT), web-based training (WBT),
               	           online education, virtual education, virtual learning environments (VLE) 
                           (which are also called learning platforms), m-learning, and digital educational 
                           collaboration. These alternative names emphasize a particular aspect, component 
                           or delivery method",
                    account_id: 2	
                )
 
                Privacypolicy.create!(
                    title: "Privacy policy",
                    desc: "Privacy policy is a statement or a legal document (privacy law) that
                    	 discloses some or all of the ways a party gathers, uses, discloses and 
                    	 manages a customer or client's data. Personal information can be anything that 
                    	 can be used to identify an individual, not limited to but including; name, address,
                    	  date of birth, marital status, contact information, ID issue and expiry date, 
                    	  financial records, credit information, medical history, where you travel, and 
                    	  intentions to acquire goods and services.[1] In the case of a business it is often
                    	  a statement that declares a party's policy on how it collects, stores, and releases 
                    	  personal information it collects. It informs the client what specific information 
                    	  is collected, and whether it is kept confidential, shared with partners, or sold to 
                    	  other firms or enterprises",
                    account_id: 2 
                )

                    TermsAndCondition.create!(
                  	title:"Terms and condtions",
                    desc:"By using this service, you agree that you have read, understand 
                          and agree to these terms. You also agree to review this agreement 
                          periodically to be aware of modifications to the agreement, which 
                          modifications goodelearning.com may make at any time. Your continued
                          use of this site will be deemed your conclusive acceptance of any modified agreement",
                    account_id: 2 
                )

                TeachingStaff.create!(
                    name: "Ram" ,
                    description: "aaaaaaa",
                    qualification: "MCA",
                    user_id: 3,
                    linkedin_profile_url: "",
                    account_id: 2
                )
                course = Course.create!(title: "Algorithm Using Program",
                    desc: "Learn Algorithm using the language of Program",
                    topic_id: 1,
                    short_desc:"Learn Algorithm using the language of Program",
                    ispublished: 1 ,
                    ispopular: 1 ,
                    start_date: '2013-08-03' ,
                    end_date: '2013-12-03',
                    isconcluded: "false",
                    account_id: 2
                )

                course1 = Course.create!(title: "SOCIAL MEDIA",
                    desc: "Learn web applications and create new social media",
                    topic_id: 2,
                    short_desc:"Learn web applications and create new social media",
                    ispublished: 1 ,
                    ispopular: 1 ,
                    start_date: '2013-08-03' ,
                    end_date: '2013-12-03',
                    isconcluded: "false",
                    account_id: 2
                )

                course2 = Course.create!(title:"Technology of Networking",
                    desc: "Learn Big data send and receive using the language of Networking",
                    topic_id: 3,
                    short_desc:"Learn Big data send and receive using the language of Networking",
                    ispublished: 1 ,
                    ispopular: 0 ,
                    is_coming_soon: "TRUE",
                    start_date: '2013-08-03' ,
                    end_date: '2013-12-03',
                    isconcluded: "false",
                    account_id: 2
                )

                CoursePreview.create!(
                    name: "Algorithm Using Program",
                    desc: "Learn Algorithm using the language of Program",
                    video_url: "/www.youtube.com/embed/DF2XAc07eI0?rel=0" ,
                    sequence: "1",
                    enable: "1",
                    course_id: course.id ,
                    account_id: 2 
                )
                CoursePreview.create!(
                    name:  "SOCIAL MEDIA",
                    desc:"Learn web applications and create new social media",
                    video_url: "/www.youtube.com/embed/DF2XAc07eI0?rel=0" ,
                    sequence: "1",
                    enable: "1",
                    course_id: course1.id ,
                    account_id: 2 
                )
                CoursePreview.create!(
                    name: "Technology of Networking",
                    desc: "Learn Big data send and receive using the language of Networking",
                    video_url: "/www.youtube.com/embed/DF2XAc07eI0?rel=0" ,
                    sequence: "1",
                    enable: "1",
                    course_id: course2.id ,
                    account_id: 2 
                )

                User.create!(
                    name: "Abdul",
                    image_blob: File.read('public/images/viewlogo.png'),
                    email: "abdul@gmail.com",
                    password: "abdulabdul",
                    password_confirmation: "abdulabdul",
                    uid: 3 
                )    
     
              	

                CoursePricing.create!(course_id: course.id ,
                    price: "9000" ,
                    start_date: "2013-08-01",
                    end_date: "2014-08-31",
                    account_id:2
                )

                CoursePricing.create!(course_id: course1.id ,
                    price: "10000" ,
                    start_date: "2013-08-01",
                    end_date: "2014-08-31",
                    account_id:2
                )
                CoursePricing.create!(course_id: course2.id ,
                    price: "12000" ,
                    start_date: "2013-08-01",
                    end_date: "2014-08-31",
                    account_id:2
                )
  
          			TaxRate.create!(valid_from:"2013-08-01", valid_until:"2050-08-31",factor:0.0, is_default: true, description: "Service Tax", account_id: 2 )
          		  Coupon.create!(metadata:1 ,name: "Algorithm Using Program", description: "learning about only use the learning part and use the coupons", alpha_mask: "AA-BB-CC", digit_mask: "11-22-33", amount_one: 0.0, percentage_one: 0.0, expiration: "2014-08-01", account_id: 2 )

	end
end