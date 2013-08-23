class AccountContactDetailsController < ApplicationController
	before_filter :check_admin_user, :only=>[:new, :create, :edit, :index]
before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
 before_filter :valid_domain_check, :only=>[:show,:edit]
before_filter :front_page_registration_restrict, :only=>[:new,:create]
  def new
  	@account_contact_detail=AccountContactDetail.new
  end
  def create
  	@account_contact_detail=AccountContactDetail.new(params[:account_contact_detail])
  	@account_contact_detail.account_id=@account_id
  	if @account_contact_detail.save
  		flash[:success]="AccountContactDetail add successfully"
  		redirect_to account_contact_details_path
  	else
  		render :new
  	end
  end

  def edit
  	@account_contact_detail=AccountContactDetail.find(params[:id])
  end
  def update
  	@account_contact_detail=AccountContactDetail.find(params[:id])
  	@account_contact_detail.account_id=@account_id
  	if @account_contact_detail.update_attributes(params[:account_contact_detail])
  		flash[:success]="AccountContactDetail updated successfully"
  		redirect_to account_contact_details_path
  	else
  		render :edit
  	end
  end

  def index
  	@account_contact_detail=AccountContactDetail.all
  end

  def show
  	@account_contact_detail=AccountContactDetail.find(params[:id])
  end
end
