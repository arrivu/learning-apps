class FooterlinksController < ApplicationController
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]
  def new
  	@footerlink=Footerlink.new
  end
  def create
  	@footerlink=Footerlink.new(params[:footerlink])
  	
  	@footerlink.account_id=@account_id
  	if @footerlink.save
  		flash[:success]="FooterLinks created successfully"
  		redirect_to footerlinks_path
  	end
  end

  def edit
  	@footerlink=Footerlink.find(params[:id])
  end

  def show
  	@footerlink=Footerlink.find(params[:id])
  end

  def index
  	@footerlink=Footerlink.where(:account_id=>@account_id)
  end
  def update
  	@footerlink=Footerlink.find(params[:id])
    @footerlink.account_id=@account_id
  	if @footerlink.update_attributes(params[:footerlink])
  		flash[:success]="Footerlink details updated successfully"
  		redirect_to footerlinks_path
  	end
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
