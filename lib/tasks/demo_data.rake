#encoding: utf-8

namespace :db do

	task demo: :environment do

	

	account =Account.create! :active => true, :name=>"demo", :no_of_courses=>"0", :no_of_users=>"0", :organization=>"learning Portal"

puts 'SETTING UP DEFAULT USER LOGIN'

if Rails.env.development?
  # user =User.create! :name => 'Administrator', :email => 'learning@arrivusystems.com', :password => 'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
   user_account=User.create! :name=> 'Account Admin', :email => 'demo@arrivusystems.com',:password=>'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
# else
  # user = User.create! :name => 'Administrator', :email => 'learning@arrivusystems.com', :password => 'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
	 # user_account=User.create! :name=> 'Account Admin', :email => 'demo@arrivusystems.com',:password=>'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
end
# puts 'User created: ' << user.name
# @account_user = account.add_user(user, 'SiteAdmin')
# user.add_role :admin

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
               		 # theme_name: "#{RAILS_ROOT}/assets/images/images.jpg",
               		 theme_name: "images.jpg",
               		 # img.add_profile(filename) -> self
        

               		logo_type: "images/jpeg",
               		 theme_type: "images/jpeg",
               		
               		message: "Online Learning",
               		account_id: 2 ,
        #        		def uploaded=(images.jpg)
        # 			self.theme_name = "images.jpg".original_filename,
        # 			self.theme_type = "images.jpg".content_type,
        # 			self.theme = "images.jpg".read
    				# end
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

#            SocialStreamCommentsController.create!(twitter_comment_script: "<a class="twitter-timeline" href="https://twitter.com/abdul18rahman" data-widget-id="370430126481092609">Tweets by @abdul18rahman</a>
# <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
# ",
#            	facebook_comment_script: "<div id="fb-root"></div>
#          <script>(function(d, s, id) {
#         var js, fjs = d.getElementsByTagName(s)[0];
#          if (d.getElementById(id)) return;
#          js = d.createElement(s); js.id = id;
#          js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=585000628219186";
#          fjs.parentNode.insertBefore(js, fjs);
#           }(document, 'script', 'facebook-jssdk'));</script>
#           <div class="fb-like" data-href="http://developers.facebook.com/docs/reference/plugins/like" data-width="450" data-show-faces="true" data-send="true"></div>",
         
#            	account_id: 1)
        
		courses_hash = {
			1 => ["Algorithm Using Program", 
			 	"Learn Algorithm using the language of Program",2
			 	],
			2 => ["SOCIAL MEDIA", 
			 	"Learn web applications and create new social media",2
			 	],
			3 => ["Technology of Networking", 
			 	"Learn Big data send and receive using the language of Networking",2
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
			account_id: 2)
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
					end_date:array[3],
					account_id:2)
			end

			TaxRate.create!(valid_from:"2013-08-01", valid_until:"2050-08-31",factor:0.0, is_default: true, description: "Service Tax", account_id: 2 )
		    Coupon.create!(metadata:6,name: "Algorithm Using Program", description: "learning about only use the learning part and use the coupons", alpha_mask: "AA-BB-CC", digit_mask: "11-22-33", amount_one: 0.0, percentage_one: 0.0, expiration: "2014-08-01", account_id: 2 )
	end
end