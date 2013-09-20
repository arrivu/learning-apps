
class TeachingStaffsController < ApplicationController
  include LmsHelper
  before_filter :authenticate_user!, :except => [:teaching_staff_signup, :teaching_staff_profile,:terms]
  load_and_authorize_resource
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
  before_filter :valid_domain_check, :only=>[:show,:edit]
	protect_from_forgery :except => :create


	def new
		@teachingstaff = TeachingStaff.new
		@teachingstaff.build_user
		render 'new'
	end


	def create
		@teachingstaff = TeachingStaff.new
		@teachingstaff.name =  params[:teaching_staff][:teaching_staff_user][:name]
		@teachingstaff.description =  params[:teaching_staff][:description]
		@teachingstaff.qualification =  params[:teaching_staff][:qualification]
    @teachingstaff.linkedin_profile_url =  params[:teaching_staff][:linkedin_profile_url]

    @teachingstaff.is_active=params[:teaching_staff][:is_active]

		@teachingstaff.build_user(name: params[:teaching_staff][:teaching_staff_user][:name],
								email: params[:teaching_staff][:teaching_staff_user][:email],
								 user_type: 3,
								content_type: params[:teaching_staff][:teaching_staff_user][:content_type],
								attachment: params[:teaching_staff][:teaching_staff_user][:attachment],
								password: params[:teaching_staff][:teaching_staff_user][:password],
								password_confirmation: params[:teaching_staff][:teaching_staff_user][:password_confirmation])
		
		@teachingstaff.account_id=@account_id
      if @teachingstaff.save
			@teachingstaff.user.add_role(:teacher)
			AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")
			flash[:notice] = "Teaching Staff add successfully"
      lms_create_user(@teachingstaff.user)
      redirect_to teaching_staffs_path

		else

		render :new	
	end
	end

	def edit
		@teachingstaff=TeachingStaff.find(params[:id])

	end

  def update
    @teachingstaff=TeachingStaff.find(params[:id])

    if params[:teaching_staff][:user][:attachment]!=nil

      @teachingstaff.account_id=@account_id
      if @teachingstaff.user.update_attributes(:email => params[:teaching_staff][:user][:email],
                                               password: params[:teaching_staff][:user][:password],
                                               password_confirmation: params[:teaching_staff][:user][:password_confirmation],
                                               content_type: params[:teaching_staff][:user][:content_type],
                                               attachment: params[:teaching_staff][:user][:attachment],

                                               name:params[:teaching_staff][:user][:name]) && @teachingstaff.update_attributes(
          description:params[:teaching_staff][:description],
          linkedin_profile_url:params[:teaching_staff][:linkedin_profile_url],
          qualification:params[:teaching_staff][:qualification],
          name:params[:teaching_staff][:user][:name],
          is_active:params[:teaching_staff][:is_active]
          )

        # AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")

        flash[:notice]="Teaching Staff details updated successfully"
        redirect_to teaching_staffs_path

      else
        render 'edit'
      end
    else
      @teachingstaff.account_id=@account_id
      if @teachingstaff.user.update_attributes(:email => params[:teaching_staff][:user][:email],
                                               password: params[:teaching_staff][:user][:password],
                                               password_confirmation: params[:teaching_staff][:user][:password_confirmation],
                                               name:params[:teaching_staff][:user][:name]) && @teachingstaff.update_attributes(
          description:params[:teaching_staff][:description],
          qualification:params[:teaching_staff][:qualification],
          linkedin_profile_url:params[:teaching_staff][:linkedin_profile_url],
          name:params[:teaching_staff][:user][:name],
          is_active:params[:teaching_staff][:is_active]

      )

        # AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")

        flash[:notice]="Teaching Staff details updated successfully"
        redirect_to teaching_staffs_path

      else
        render 'edit'
      end
    end
  end

	def index
		@teachingstaff=TeachingStaff.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 10)
	end

	def destroy
		@teachingstaff=TeachingStaff.find(params[:id])
		@teachingstaff.destroy
		redirect_to teaching_staffs_path
		flash[:notice] = "Deleted teaching staff details successfully"
  end

  def teaching_staff_signup
    @teachingstaff = TeachingStaff.new
    @teaching_staff_user=  @teachingstaff.build_user
    unless params[:teaching_staff].nil?
    @teachingstaff.name =  params[:teaching_staff][:user][:name]
    @teachingstaff.description =  params[:teaching_staff][:description]
    @teachingstaff.qualification =  params[:teaching_staff][:qualification]
    @teachingstaff.linkedin_profile_url =  params[:teaching_staff][:linkedin_profile_url]
    @teachingstaff.is_active =false
    @teachingstaff.build_user(name: params[:teaching_staff][:user][:name],
                              email: params[:teaching_staff][:user][:email],
                              user_type: 3,
                              content_type: params[:teaching_staff][:user][:content_type],
                              attachment: params[:teaching_staff][:user][:attachment],
                              password: params[:teaching_staff][:user][:password],
                              password_confirmation: params[:teaching_staff][:user][:password_confirmation])

    @teachingstaff.account_id=@account_id
    if @teachingstaff.save
      @teachingstaff.user.add_role(:teacher)
      AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")
      lms_create_user(@teachingstaff.user)
      flash[:notice] = "Account has been created.However you cannot login now ,Once your Account is verified the admin
                        will contact you ! "
      unless Rails.env.development?
        UserMailer.teaching_staffs_welcome(@teachingstaff).deliver!
      end
      redirect_to root_path

    else
      @teachingstaff.errors.messages.merge!(:teaching_staff_user.errors) unless @teachingstaff.valid?
     render :teaching_staff_signup
    end
   end
  end

  def activate_teaching_staff
    @teachingstaff=TeachingStaff.find(params[:id])
    @teachingstaff.is_active = params[:teaching_staff][:is_active]
    if @teachingstaff.save!
      if @teachingstaff.is_active?
        unless Rails.env.development?
          UserMailer.teaching_staffs_activation(@teachingstaff).deliver!
        end
        redirect_to teaching_staffs_path
        flash[:success] = "User Sucessfully activated and activation mail sent !"
      else
        redirect_to teaching_staffs_path
        flash[:info] = "Teaching Staff Sucessfully Updated"
      end
    end

  end

  def teaching_staff_profile

   @teaching_staff=current_user.teaching_staff
   #@userid=@teachingstaff.user_id
   #@user=User.find(@userid)
   #@count=@user.sign_in_count
   @account=@domain_root_account
   @account_id=@account.id
   #@terms=TermsAndCondition.find(@account_id)
   unless params[:teaching_staff].nil?
    if @teaching_staff.update_attributes(:headline=>params[:teaching_staff][:headline],
                                        :biography=>params[:teaching_staff][:biography],
                                                          :address=>params[:teaching_staff][:address],
                                                          :city =>params[:teaching_staff][:city],
                                                          :pincode =>params[:teaching_staff][:pincode],
                                                          :phone_number=>params[:teaching_staff][:phone_number],
                                                          :firstname=>params[:teaching_staff][:firstname],
                                                        :lastname=> params[:teaching_staff][:lastname])

     flash[:success]="Teaching Staff details updated successfully"
      redirect_to my_courses_path
    else
     render :teaching_staff_profile
      end
    end
  end

  def terms
    @account=@domain_root_account
    @account_id=@account.id
    @terms=TermsAndCondition.find(@account_id)
    if @terms==nil
          redirect_to  :terms
    else
      @terms
    end


  end


end
