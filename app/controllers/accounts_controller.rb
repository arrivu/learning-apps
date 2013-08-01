class AccountsController < ApplicationController
    before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy,:index]
    before_filter :subdomain_authentication, :only  => [:new,:create,:edit,:show,:update,:destroy,:index]
  def new
  	@account=Account.new
  end
  def create
  	@account=Account.new(params[:account])
  	if @account.save
  		flash[:success]="Account details created Successfully"
  		redirect_to accounts_path
  	end
end


  def edit
  	@account=Account.find(params[:id])
  end
  def update
  	@account=Account.find(params[:id])
  	if @account.update_attributes(params[:account])
  		flash[:success]="Account details updated Successfully"
  		redirect_to accounts_path
  	end
  end

  def show
  	@account=Account.where(:subdomain => request.subdomain)
  end

  def index
  	# 
  	@account=Account.all
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
