class PrivacypoliciesController < ApplicationController
  load_and_authorize_resource
   before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
   before_filter :valid_domain_check, :only=>[:show,:edit]
   before_filter :front_page_registration_restrict, :only=>[:new,:create]
   caches_action :index,:show

  def new
    @privacy = Privacypolicy.find_by_account_id(@account_id)
    if @privacy == nil
      @privacypolicy=Privacypolicy.new
      expire_action action: [:index,:show]
    else
      redirect_to privacypolicies_path
    end
  end

  def create
	        @privacypolicy= Privacypolicy.new(params[:privacypolicy])
           @privacypolicy.account_id=@account_id
			    if @privacypolicy.save
            expire_action action: [:index,:show]
			      flash[:success] = "PrivacyPolicy added successfully!!!!"
			       # redirect_to @privacypolicy
              redirect_to privacypolicies_path
            expire_action action:[:index,:show]
			    else
			      render :action => 'new'
			    end
  end

  def show
  	@privacypolicy = Privacypolicy.find(params[:id])
  end

  def index
		 @privacypolicy=Privacypolicy.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 10)
  end

  def edit
  	@privacypolicy=Privacypolicy.find(params[:id])
  end

  def update
     		 @privacypolicy = Privacypolicy.find(params[:id])
         @privacypolicy.account_id=@account_id
     		 if @privacypolicy.update_attributes(params[:privacypolicy])
            expire_action action: [:index,:show]
        		flash[:success] = "PrivacyPolicy updated"
        			redirect_to privacypolicies_path
        	else
        			render :action => 'edit'
      		end
 	end
 	def destroy
			@privacypolicy = Privacypolicy.find(params[:id])
			@privacypolicy.destroy
      expire_action action: [:index,:show]
			flash[:success] = "Testimonial Deleted"
			redirect_to privacypolicies_path
	end
   
end
