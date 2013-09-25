
Myapp::Application.routes.draw do


resources :omniauth_links
resources :social_stream_comments
resources :header_details

match '/' => 'blogs#show', :constraints => {:subdomains => /.+/}
resources :footerlinks

  themes_for_rails
  resources :themes
  resources :omniauth_links
  resources :social_stream_comments
  resources :header_details
  resources :account_themes
  resources :footerlinks

  resources :accounts
  match 'teaching_staffs/new',:to=>'teaching_staffs#new'
  resources :course_pricings
  resources :teaching_staffs
  resources :tax_rates
  resources :coupons do
    collection do
      get 'test'
      get 'apply'
      get 'redeem'
      end
  end
  resources :sliders
  resources :contacts
  resources :courses
  resources :testimonials
  resources :partners
  resources :privacypolicies
  resources :terms_and_conditions
  resources :aboutdetails
  resources :add_images
  match '/rate' => 'rater#create', :as => 'rate'
  match 'teaching_staffs/new',:to=>'teaching_staffs#new'
  match 'payments/course_payment_gateway',:to=>'payments#course_payment_gateway'
  match 'payments/course_payment',:to=>'payments#course_payment'
  match 'payments/follow_course',:to=>'payments#follow_course'
  match 'payments/confirm_course_payment',:to=>'payments#confirm_course_payment'
  match "/download_pdf(.:format)" => "payments#invoice_pdf", :method => :get, :as=>:invoice_pdf

  resources :topics
  resources :tutorials
  resources :under_constructions
  resources :course_previews

  authenticated :user do
    root :to => 'screens#home'
  end
  root :to => 'screens#home'
  match '/about', :to => 'screens#about'
  match '/privacy', :to => 'screens#privacy'
  match '/termscondition', :to => 'screens#termscondition'
  match '/knowledge_partners', :to => 'screens#knowledge_partners'
  match '/user_reviews', :to => 'screens#user_reviews'
  match '/construction', :to => 'screens#construction'
  match '/manage_courses', :to => 'courses#manage_courses'
  match '/upcomming_courses', :to => 'courses#upcomming_courses'
  match '/popular_courses', :to => 'courses#popular_courses'
  match '/datewise_courses', :to => 'courses#datewise_courses'
  match '/subscribed_courses', :to => 'courses#subscribed_courses'
  match '/course_status_search', :to => 'courses#course_status_search'
  match '/completed_courses', :to => 'courses#completed_courses'
  match '/updatecompleted_details', :to => 'courses#updatecompleted_details'
  match '/conclude_course', :to =>'courses#conclude_course'
  match '/concluded_course_update', :to=> 'courses#concluded_course_update'
  match '/concluded_courses', :to=> 'courses#concluded_courses'
  match '/edit_concluded_course', :to=> 'courses#edit_concluded_course'
  match '/update_un_concluded_course', :to=> 'courses#update_un_concluded_course'
  match '/interested_users', :to=> 'users#interested_users'
  match '/teaching_courses', :to=> 'users#teaching_courses'

  devise_for :users, :controllers => {:registrations => "registrations",:sessions => "sessions"}

  devise_scope :user do
    match '/user_image/:id', :to => 'registrations#user_image'
  end

  resources :users
  match '/auth/:provider/callback' => 'authentication#create'
  resources :comments, :path_prefix => '/:commentable_type/:commentable_id'
  match '/my_courses', :to => 'courses#my_courses'
  match '/show_image/:id', :to => 'courses#show_image'
  match '/background_image/:id', :to => 'courses#background_image'
  match '/show_image_slider/:id', :to => 'sliders#show_image_slider'
  match '/background_image_slider/:id', :to => 'sliders#background_image_slider'
  match '/show_image_detail/:id', :to => 'header_details#show_image_detail'
  match '/theme_image_detail/:id', :to => 'header_details#theme_image_detail'
  match '/show_image_show/:id', :to => 'header_details#show_image_show'
  match '/theme_image_show/:id', :to => 'header_details#theme_image_show'
  match '/show_image_logo/:id', :to => 'screens#show_image_logo'
  match '/theme_header_image/:id', :to => 'screens#theme_header_image'
  match '/add_sub_topics', :to => 'topics#add_sub_topics'

  devise_scope :user do
    match '/sign_out', :to => 'users#destroy'
  end
  match '/add_account_id', :to=>'courses#add_account_id'
  resources :themes
  resources :tags
  resources :teaching_staffs
  match '/tagged_courses', :to =>'courses#tagged_courses'
  match 'teaching_staff_signup', :to => 'teaching_staffs#teaching_staff_signup'
  match'update_settings' , :to=> "accounts#update_settings"
  match'activate_teaching_staff', :to=> 'teaching_staffs#activate_teaching_staff'
  match 'subscribe', :to=> 'accounts#subscribe'
  match 'teaching_staff_profile', :to =>'teaching_staffs#teaching_staff_profile'
  match 'account_subscription', :to =>'accounts#account_subscription'
  match 'terms', :to =>'terms_and_conditions#terms'
  match 'review', :to => 'courses#review' 
  match 'account_subscription', :to =>'accounts#account_subscription'
  match 'authenticate', :to=> 'accounts#authenticate'
end