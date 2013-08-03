class FooterlinksController < ApplicationController
  before_filter :check_admin_user,  :only=>[:new, :create, :edit, :index]
   before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
    before_filter :valid_domain_check, :only=>[:show,:edit]
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
  
end
