  class TeachingStaffsController < ApplicationController
  include LmsHelper
  before_filter :authenticate_user!, :except => [:teaching_staff_signup, :teaching_staff_profile,:terms]
  load_and_authorize_resource
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
  before_filter :valid_domain_check, :only=>[:show,:edit]
  before_filter :delete_in_lms ,:only=> [:destroy]
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
								avatar: params[:teaching_staff][:teaching_staff_user][:avatar],
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
    @teachingstaff.account_id=@account_id
    if @teachingstaff.user.update_attributes(:email => params[:teaching_staff][:user][:email],
                              password: params[:teaching_staff][:user][:password],
                              password_confirmation: params[:teaching_staff][:user][:password_confirmation],
                              avatar: params[:teaching_staff][:user][:avatar],
                              name:params[:teaching_staff][:user][:name]) &&
       @teachingstaff.update_attributes(
          description:params[:teaching_staff][:description],
          linkedin_profile_url:params[:teaching_staff][:linkedin_profile_url],
          qualification:params[:teaching_staff][:qualification],
          name:params[:teaching_staff][:user][:name],
          is_active:params[:teaching_staff][:is_active]
          )
        expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
        flash[:notice]="Teaching Staff details updated successfully"
        redirect_to teaching_staffs_path
    else
      flash[:error]="There is some error while saving teaching staff details"
        render 'edit'
      end
  end

	def index
		@teachingstaff=TeachingStaff.order('created_at').where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 30)
	end

	def destroy
		@teachingstaff=TeachingStaff.find(params[:id])
		@teachingstaff.destroy
		redirect_to teaching_staffs_path
		flash[:notice] = "Deleted teaching staff details successfully"
  end

  def teaching_staff_signup
   if @domain_root_account.settings[:signup_teacher_enable] == true
     @teachingstaff = TeachingStaff.new
     @teaching_staff_user=  @teachingstaff.build_user
     unless  params[:teaching_staff].nil?
       @teachingstaff.name =  params[:teaching_staff][:user][:name]
       @teachingstaff.description =  params[:teaching_staff][:description]
       @teachingstaff.qualification =  params[:teaching_staff][:qualification]
       @teachingstaff.linkedin_profile_url =  params[:teaching_staff][:linkedin_profile_url]
       @teachingstaff.is_active =false
       @teachingstaff.build_user(name: params[:teaching_staff][:user][:name],
                                email: params[:teaching_staff][:user][:email],
                                user_type: 3,
                                password: params[:teaching_staff][:user][:password],
                                password_confirmation: params[:teaching_staff][:user][:password_confirmation])

       @teachingstaff.account_id=@domain_root_account.id
       if @teachingstaff.save
         @teachingstaff.user.add_role(:teacher)
         AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@domain_root_account.id,:membership_type => "teacher")
         lms_create_user(@teachingstaff.user)
         flash[:info] = "Account has been created.However you cannot login now ,Once your Account is verified the admin
                        will contact you ! "
         unless Rails.env.development?
           UserMailer.delay.teaching_staffs_welcome(@teachingstaff)
         end
         redirect_to root_path
         else
           render :teaching_staff_signup
           end
       end
   else
     root_path
     flash[:notice] = "You are not authorized to access this page"
   end
  end


  def activate_teaching_staff
    @teachingstaff=TeachingStaff.find(params[:id])
    @teachingstaff.is_active = params[:teaching_staff][:is_active]
    if @teachingstaff.save!
      if @teachingstaff.is_active?
        unless Rails.env.development?
          UserMailer.delay.teaching_staffs_activation(@teachingstaff)
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
   @teaching_staff.terms_of_service=params[:teaching_staff][:terms_of_service]
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
    @terms=TermsAndCondition.find(@domain_root_account.id)
    if @terms.nil?
          redirect_to  :terms
    else
      @terms
    end


  end

  end




