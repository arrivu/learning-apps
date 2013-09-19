class AccountsController < ApplicationController
load_and_authorize_resource
before_filter :subdomain_authentication, :only  => [:new,:create,:edit,:show,:update,:destroy,:index]


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

    def subscribe
      @account=Account.new(params[:account])
      params[:account][:name]=@account.name.downcase
      if @account.save
        flash[:success]="Account details created Successfully"
        redirect_to accounts_path
      else
        render "new"
      end
    end

 def account_subscription
      @account=Account.new
      @user=User.new
   unless params[:user].nil?
     unless params[:user][:account].nil?
         @account.name=params[:user][:account][:name]
         @account.organization=params[:user][:account][:organization]
         @account.terms_of_service=params[:user][:account][:terms_of_service]
         @user=User.new(name: params[:user][:name],
                              email: params[:user][:email],
                              user_type: 2,
                              content_type: params[:user][:content_type],
                              attachment: params[:user][:attachment],
                              password: params[:user][:password],
                              password_confirmation: params[:user][:password_confirmation])
           if @account.save  && @user.save
            @user.add_role(:account_admin)
            AccountUser.create!(:user_id=>@user.id,:account_id=>@account.id,:membership_type => "AccountAdmin")
            flash[:success]="Accounts created Successfully"

            redirect_to root_path
           else
             @user.errors.messages.merge!(@account.errors) unless @user.valid?
             render :account_subscription
           end
       end

     end
  end
 end
#end

