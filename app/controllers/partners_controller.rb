class PartnersController < ApplicationController

    before_filter :check_admin_user,:only => [:new,:create,:edit,:update,:destroy]

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
  	 @partner=Partner.where(:account=>@account_id).paginate(page: params[:page], :per_page => 10)
      

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
     @partner.account_id=@account_id
      @partner.account_id=@account_id
    @partner = Partner.find(params[:id])
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
end
