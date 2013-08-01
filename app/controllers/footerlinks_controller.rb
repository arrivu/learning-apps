class FooterlinksController < ApplicationController
  before_filter :subdomain_authentication , :only => [:new,:create, :index, :edit, :destroy]
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
