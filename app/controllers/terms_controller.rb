class TermsController < ApplicationController
	before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]
 		 def new
	  		@term=Term.new
	    end
	    def create
	        @term = Term.new(params[:term])

	        @term.account_id=@account_id
			    if @term.save
			      flash[:success] = "Terms added successfully!!!!"
			     
			      redirect_to terms_path

			    else
			      render :action => 'new'
			    end
        end 

        def edit
    		@term=Term.find(params[:id])
  		end
  		def update
     		 @term = Term.find(params[:id])
     		  @term.account_id=@account_id
     		 if @term.update_attributes(params[:term])
        		flash[:success] = "Terms updated"
        			redirect_to terms_path
        	else
        			render :action => 'edit'
      		end
 		end	
 		def index
 			 @term=Term.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 10)
		end
		def show
				@term = Term.find(params[:id])
		end
		def destroy
			@term = Term.find(params[:id])
			@term.destroy
			flash[:success] = "Terms Deleted"
			redirect_to terms_path
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
