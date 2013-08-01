class PartnersController < ApplicationController

    before_filter :check_admin_user,:only => [:new,:create,:edit,:update,:destroy]
    before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]

  def new
    
  	@partner=Partner.new

  end
  def  create
    
		@partner = Partner.new(params[:partner])

	   @partner.account_id=@account_id
			if @partner.save
			  flash[:success] = "Details added "
			      # NewsletterMailer.weekly("ankithbti007@gmail.com", flash[:success]).deliver
			  redirect_to partners_path

			else
			  render :action => 'new'
			end
  end	
  def edit
  	@partner=Partner.find(params[:id])

  end

  def index
  	 @partner=Partner.where(:account_id => @account_id).paginate(page: params[:page], :per_page => 15)

  end
  # def showimage
  #    @partner = Partner.find(params[:id])
  #     send_data @partner.image, :type => @partner.image_type, :disposition => 'inline'
  # end


 
  
  def show
    @partner = Partner.find(params[:id])

      send_data @partner.image, :type => @partner.image_type, :disposition => 'inline' 

   # 

  end
  def update
    
      
    @partner = Partner.find(params[:id])
    @partner.account_id=@account_id
         if @partner.update_attributes(params[:partner])
            flash[:success] = "Partners Details updated"
              redirect_to partners_path
          else
              render :action => 'edit'
          end
  end  
  def destroy
      @partner = Partner.find(params[:id])
      @partner.destroy
      flash[:success] = "Partners Details Deleted"
      redirect_to partners_path
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
