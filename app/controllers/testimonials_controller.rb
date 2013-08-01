class TestimonialsController < ApplicationController
  before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy,:index]
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
		
		def new
	  		@testimonial=Testimonial.new
	    end
	    def create
	        @testimonial = Testimonial.new(params[:testimonial])
	        @testimonial.account_id=@account_id
			    if @testimonial.save
			      flash[:success] = "Testimonial added successfully!!!!"
			      # NewsletterMailer.weekly("ankithbti007@gmail.com", flash[:success]).deliver
			      redirect_to testimonials_path

			    else
			      render :action => 'new'
			    end
        end 

        def edit
    		@testimonial=Testimonial.find(params[:id])
  		end
  		def update
     		 @testimonial = Testimonial.find(params[:id])
     		  @testimonial.account_id=@account_id
     		 if @testimonial.update_attributes(params[:testimonial])
        		flash[:success] = "Testimonial updated"
        			redirect_to testimonials_path
        	else
        			render :action => 'edit'
      		end
 		end	
 		def index
 			 @testimonial=Testimonial.where(:account_id=>@account_id)
		end
		def show
				@testimonial = Testimonial.find(params[:id])
		end
		def destroy
			@testimonial = Testimonial.find(params[:id])
			@testimonial.destroy
			flash[:success] = "Testimonial Deleted"
			redirect_to testimonials_path
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
