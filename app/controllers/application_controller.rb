  class ApplicationController < ActionController::Base
    add_breadcrumb "home", :root_path
    protect_from_forgery
    before_filter :load_account
    before_filter :topics
   # before_filter :theme_create
   # before_filter :set_mailer_settings
    include ApplicationHelper
    include CoursesHelper
    include SessionsHelper
    include PaymentsHelper 
    include UrlHelper   
    include SubdomainHelper
    
    include ActiveMerchant::Billing::Integrations::ActionViewHelper
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path, :alert => exception.message
  end
  include TaxRatesHelper
  def theme_create
     @account_theme= @domain_root_account.account_theme
    if  @account_theme!=nil
     theme @account_theme.name
    else
    theme "default"
    end
  end
    

  def after_sign_in_path_for(resource_or_scope)

    if redirect_back_req?
      redirect_back    
    elsif current_user.has_role? :admin 
     users_path
   elsif current_user.has_role? :account_admin
    users_path

   elsif current_user.has_role :teacher
     @count=current_user.sign_in_count
     if(@count== 1)
       #render "teaching_staffs/teaching_staff_profile.html.erb"

       teaching_staff_profile_path
     else
       my_courses_path
      end
    else
      student=Student.where(user_id: current_user.id).first
      if student !=nil 
        if student.course_enroll.count == 0
          courses_path
        else
          my_courses_path
        end
      else
        courses_path
      end
    end
  end

  def raise_exception
   raise 'This is a test for exception.'
  end

  def render_not_found(exception)
    render :template => "/errors/404.html.erb",
           :layout => 'application.html.erb'
  end
   
  def render_error(exception)
    render_not_found(nil)
  end
  
  def routing_error
  render_not_found(nil)
  end


   def load_account
      unless current_subdomain.nil?
         @domain_root_account= Account.find_by_name current_subdomain
             if (@domain_root_account == nil)
                   redirect_to request.url.sub(current_subdomain, Account.default.name)
                else
               @account_id= @domain_root_account.id
             end
       else
            @domain_root_account=Account.default
       end

    end
  def valid_domain_check
    if controller_name== "payments"
      @modelname="Course"
    else
       @modelname=controller_name.classify
    end
        @coursedet= @modelname.constantize.find(params[:id])
    if @account_id!=nil

        if @coursedet.account_id == @account_id
          return

        else
          flash[:error]="Invalid domain"
        end
      end
  end

      def topics
        @topics=Topic.where("parent_topic_id!=root_topic_id AND account_id =?", @domain_root_account.id)
        @topics = @topics.sort_by {|x| x.name.length} 
        @footerlinks = Footerlink.where(:account_id=> @domain_root_account.id)
        @social_stream_comments=SocialStreamComment.where(:account_id=> @domain_root_account.id)
        @header_details = HeaderDetail.where(:account_id=>@domain_root_account.id)
    end

    def front_page_registration_restrict
        return
    end

    private

    def set_mailer_settings

      ActionMailer::Base.smtp_settings = {
          :address  => @domain_root_account.settings[:mailserver_address],
          :port  => @domain_root_account.settings[:mailserver_port],
          :domain => @domain_root_account.settings[:mailserver_domain],
          :authentication => "plain",
          :enable_starttls_auto => true,
          :user_name => @domain_root_account.settings[:mailserver_user_name] ,
          :password => @domain_root_account.settings[:mailserver_password] }

    end

end
