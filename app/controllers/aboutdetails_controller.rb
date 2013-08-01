class AboutdetailsController < ApplicationController
 		  def new
	  		@aboutdetail=Aboutdetail.new
	    end
	    def create
	        @aboutdetail = Aboutdetail.new(params[:aboutdetail])
	        @aboutdetail.account_id=@account_id
			    if @aboutdetail.save
			      flash[:success] = "About Detail added successfully!!!!"
			      # NewsletterMailer.weekly("ankithbti007@gmail.com", flash[:success]).deliver
			      redirect_to aboutdetails_path

			    else
			      render :action => 'new'
			    end
      end 

      def edit
    		@aboutdetail=Aboutdetail.find(params[:id])
  		end
  		def update
     		 @aboutdetail = Aboutdetail.find(params[:id])
     		 @aboutdetail.account_id=@account_id
     		 if @aboutdetail.update_attributes(params[:aboutdetail])
        		flash[:success] = "About Detail updated"
        		redirect_to aboutdetails_path
        else
        			render :action => 'edit'
      	end
 			end	
 			def index
 			 	@aboutdetail=Aboutdetail.where(:account_id => @account_id).paginate(page: params[:page], :per_page => 10)
			end
			def show
				@aboutdetail = Aboutdetail.find(params[:id])
			end
			def destroy
				@aboutdetail = Aboutdetail.find(params[:id])
				@aboutdetail.destroy
				flash[:success] = "Testimonial Deleted"
				redirect_to aboutdetails_path
			end 
end
