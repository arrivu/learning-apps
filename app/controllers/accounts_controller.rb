class AccountsController < ApplicationController
    before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy,:index]
    before_filter :subdomain_authentication, :only  => [:new,:create,:edit,:show,:update,:destroy,:index]
    before_filter :account_create_restrict
   


  def new
  	@account=Account.new
  end


  def create
  	@account=Account.new(params[:account])
     params[:account][:name]=@account.name.downcase
  	if @account.save
  		flash[:success]="Account details created Successfully"
  		redirect_to accounts_path
    else
      render "new"
  	end
end
  def edit
  	@account=Account.find(params[:id])
  end
  def update
  	@account=Account.find(params[:id])
    params[:account][:name]=@account.name.downcase
   

  	if @account.update_attributes(params[:account])
  		flash[:success]="Account details updated Successfully"
  		redirect_to accounts_path
    else
       render "edit"
  	end
  end

  def show
  	@account=Account.where(:subdomain => request.subdomain)
  end

  def index
     if current_user.has_role? :account_admin 
      redirect_to users_path
     end
      
  	@account=Account.all


end

  def update_settings
   @domain_root_account.settings=params[:update_settings]
   @domain_root_account.save!
      render :update_settings
  end
end
