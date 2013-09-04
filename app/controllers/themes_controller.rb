class ThemesController < ApplicationController
	before_filter :theme_check_create_admin
  def new
  	@themes = Theme.new
  end 
  def create
  	@themes=Theme.new(params[:theme])
  	# @themes.account_id= @domain_root_account.id
  	# Theme.wh
  	if @themes.save
  		flash[:success]="Theme Created Successfully"
  		redirect_to themes_path
  	else 
  		render :new
  	end
  			
  end
  def index
  	@themes=Theme.all
  end

  def show
  	@themes=Theme.find(params[:id])
  end

  def edit
  	@themes=Theme.find(params[:id])
  end
  def update
  		@themes=Theme.find(params[:id])
  		if @themes.update_attributes(params[:theme])
  			flash[:success]="Theme Updated Successfully"
  			redirect_to themes_path
  		else
  			render :edit
  		end
  end
end
