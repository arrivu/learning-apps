class OmniauthLinksController < ApplicationController
  def new
  	@omniauth_link=OmniauthLink.new
  end

  def edit
  		@omniauth_link=OmniauthLink.find(params[:id])
  end
  def create
  	@omniauth_link=OmniauthLink.new(params[:omniauth_link])
  	@omniauth_link.account_id=@account_id
  	if @omniauth_link.save
  		flash[:success]="OmniauthLink details Add Successfully"
  		redirect_to omniauth_links_path
  	else
  		render 'new'
  	end
  end
  def update
  	@omniauth_link=OmniauthLink.find(params[:id])
  	@omniauth_link.account_id=@account_id
  	if @omniauth_link.update_attributes(params[:omniauth_link])
  		flash[:success]="OmniauthLink details Add Successfully"
  		redirect_to omniauth_links_path
  	else
  		render 'edit'
  	end
  end

  def index
  	@omniauth_link=OmniauthLink.where(:account_id=>@account_id)
  end

  def show
  	@omniauth_link=OmniauthLink.find(params[:id])
  end
end
