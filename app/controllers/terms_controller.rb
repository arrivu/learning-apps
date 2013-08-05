class TermsController < ApplicationController
	before_filter :check_admin_user, :only=>[:new, :create, :edit, :index]
	 before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
	  before_filter :valid_domain_check, :only=>[:show,:edit]
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
		
end
