
class TeachingStaffsController < ApplicationController
  include LmsHelper
  before_filter :authenticate_user!
  before_filter :check_admin_user
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
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

	# def create
	# 	@teachingstaff=TeachingStaff.new(params[:teaching_staff])
	# 	if @teachingstaff.save
	# 		flash[:notice]="Teaching Staff details created successfully"
	# 		redirect_to new_teaching_staff_path
	# 	else
	# 		render 'new'
	# 	end			
	# end

	def edit
		@teachingstaff=TeachingStaff.find(params[:id])


		#@teachingstaff.build_user
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
									name:params[:teaching_staff][:user][:name])
									AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")
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
									name:params[:teaching_staff][:user][:name]
									
								)
								AccountUser.create(:user_id=>@teachingstaff.user.id,:account_id=>@account_id,:membership_type => "teacher")
									
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
