  class ApplicationController < ActionController::Base
    before_filter :load_account
   
    before_filter :topics
    before_filter :theme_create
    
    protect_from_forgery
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
     @account_theme= AccountTheme.find_by_account_id(@domain_root_account.id)
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
                @account_id=Account.find_by_name(current_subdomain).id
            end
           
          else
            @domain_root_account=Account.default

            
      end

    end
    def valid_domain_check
 # get the model name using controller_name.classify.constantize
 
  if controller_name== "payments"
    @modelname="Course"
  else
     @modelname=controller_name.classify
  end
      @coursedet= @modelname.constantize.find(params[:id])
    if @account_id!=nil
      if @coursedet.account_id!=@account_id
        flash[:error]="Invalid domain"
        if current_user.has_role? :admin
         redirect_to users_path
       elsif current_user.has_role? :account_admin
        redirect_to users_path
        else
          redirect_to courses_path
        end
      end
    else
      
      if @coursedet.global==true
        
        return
      else
        flash[:error]="Invalid domain"
        redirect_to courses_path
      end
    end


    end

    def topics
       @topics=Topic.where("parent_topic_id!=root_topic_id AND account_id =?", @account_id)
        @topics = @topics.sort_by {|x| x.name.length} 
        @footerlinks=Footerlink.where(:account_id=>@account_id)
        @social_stream_comments=SocialStreamComment.where(:account_id=>@account_id)
        @header_details = HeaderDetail.where(:account_id=>@account_id)
    end

    def front_page_registration_restrict 
       @front_page= controller_name.classify.constantize.find_by_account_id(@account_id)
       if @front_page!=nil
        redirect_to users_path
      else
        return
      end
    end
    
 
end
