class TermsAndConditionsController < ApplicationController
  load_and_authorize_resource
	 before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
	  before_filter :valid_domain_check, :only=>[:show,:edit]
 		 def new
	  		@terms_and_condition=TermsAndCondition.new
	    end
	    def create
	        @terms_and_condition = TermsAndCondition.new(params[:terms_and_condition])

	        @terms_and_condition.account_id=@account_id
			    if @terms_and_condition.save
			      flash[:success] = "Terms added successfully!!!!"
			     
			      redirect_to terms_and_conditions_path

			    else
			      render :action => 'new'
			    end
        end 

        def edit
    		@terms_and_condition=TermsAndCondition.find(params[:id])
  		end
  		def update
     		 @terms_and_condition = TermsAndCondition.find(params[:id])
     		  @terms_and_condition.account_id=@account_id
     		 if @terms_and_condition.update_attributes(params[:terms_and_condition])
        		flash[:success] = "Terms updated"
        			redirect_to terms_and_conditions_path
        	else
        			render :action => 'edit'
      		end
 		end	
 		def index
 			 @terms_and_condition=TermsAndCondition.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 10)
		end
		def show
				@terms_and_condition = TermsAndCondition.find(params[:id])
		end
		def destroy
			@terms_and_condition = TermsAndCondition.find(params[:id])
			@terms_and_condition.destroy
			flash[:success] = "Terms Deleted"
			redirect_to terms_and_conditions_path
    end

    def terms

      @terms_and_conditions = TermsAndCondition.find_by_account_id(@domain_root_account.id)
    end

end
