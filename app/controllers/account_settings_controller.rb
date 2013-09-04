class AccountsController < ApplicationController
before_filter :check_admin_user, :only=>[:new, :create, :edit, :index]
before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
before_filter :valid_domain_check, :only=>[:show,:edit]
before_filter :front_page_registration_restrict, :only=>[:new,:create]

  def new
      @account_setting = Account.new
  end


  def create
  
    
  	@account_setting = Account.new(params[:account_setting])
    @account_setting.account_id=@account_id
    
  	if @account_setting.save
  	flash[:success] = "Sucessfully created"
  	redirect_to account_settings_path
  end
  end	

  def edit
   
        @account_setting = Account.find(params[:id])
    

  end

  def show
   @account_setting = Account.find(params[:id])
  end

  def update
   @account_setting = Account.find(params[:id])
   @account_setting.account_id=@account_id
     if @account_setting.update_attributes(params[:account_setting])
      flash[:success] ="Successfully Updated Category."
      redirect_to account_settings_path
     end
  end
  def index
   @account_setting = Account.where(:account_id=>@account_id).paginate(page: params[:page])
  end

  def destroy
   @account_setting = Account.find(params[:id])
    @account_setting.destroy
    flash[:success] = "Successfully Destroyed Category."
    redirect_to account_settings_path
  end
end
