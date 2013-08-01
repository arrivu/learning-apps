class PrivacypoliciesController < ApplicationController
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]
  def new
  	@privacypolicy=Privacypolicy.new
  end
 def create
	        @privacypolicy= Privacypolicy.new(params[:privacypolicy])
           @privacypolicy.account_id=@account_id
			    if @privacypolicy.save
			      flash[:success] = "PrivacyPolicy added successfully!!!!"
			       # redirect_to @privacypolicy
              redirect_to privacypolicies_path
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
        		flash[:success] = "PrivacyPolicy updated"
        			redirect_to privacypolicies_path
        	else
        			render :action => 'edit'
      		end
 		end
 		def destroy
			@privacypolicy = Privacypolicy.find(params[:id])
			@privacypolicy.destroy
			flash[:success] = "Testimonial Deleted"
			redirect_to privacypolicies_path
		end 
    def subdomain_authentication
       :authenticate_user!

      if current_user.has_role :admin
       @subdomain_id= AccountUser.find_by_user_id(current_user.id)
        @subdomain_name=Account.find_by_name(@subdomain_id.account_id)
      if  @account_id==@subdomain_id.account_id
        return
      else
        redirect_to request.url.sub(current_subdomain, @subdomain_id.account.name)
        # redirect_to root_path(:subdomain => @subdomain_name)
      end
    end
   end
end
