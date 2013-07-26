class TestimonialsController < ApplicationController
  before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy,:index]
		
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
 			 @testimonial=Testimonial.where(:account_id=>@account_id)(page: params[:page], :per_page => 10)
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
end
