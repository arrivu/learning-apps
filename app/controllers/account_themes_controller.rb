class AccountThemesController < ApplicationController
before_filter :theme_check_create_admin
before_filter :front_page_registration_restrict, :only  => [:new,:create]
	def new
		@accountthemes = AccountTheme.new
	end
	def create
		@accountthemes = AccountTheme.new(params[:account_theme])
		@accountthemes.account_id=@domain_root_account.id
       if @accountthemes.save
       	flash[:message] = "Theme save"
       	redirect_to account_themes_path
      else
      	 render :new
    end
    end
    def edit
    	@accountthemes=AccountTheme.find(params[:id])
    end
    def show

          @accountthemes=AccountTheme.find(params[:id])
    end
    def index
    	@accountthemes = AccountTheme.where(:account_id=>@domain_root_account.id)
    end
    def update
    	@accountthemes=AccountTheme.find(params[:id])
    	@accountthemes.account_id=@domain_root_account.id
  		if @accountthemes.update_attributes(params[:account_theme])
  			flash[:success]="Theme Updated Successfully"
  			redirect_to account_themes_path
  		else
  			render :edit
  		end
    end	

end
