class CoursePreviewsController < ApplicationController
before_filter :check_admin_user, :only => [:new,:create, :edit, :destroy,:index]
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
	def new
		@preview = CoursePreview.new	
		#@course = Course.all
	end

	def create
		
		@course=Course.find(params[:id])
		params[:course_preview][:account_id]=@account_id
		@preview =@course.course_previews.build(params[:course_preview])
		# @preview.account_id=
		if @preview.save
			flash[:success] = "Preview Added Successfully."
			redirect_to course_previews_path
		else
		
		render 'new'

		end
	end

	def index
		@previews = CoursePreview.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 10)
		@course = Course.where(:account_id=>@account_id)
		
		
	end

	def edit
		@preview= CoursePreview.find(params[:id])
		@course = Course.all
	end

	def update
		@preview = CoursePreview.find(params[:id])
	   		@preview.account_id=@account_id
		if @preview.update_attributes(params[:course_preview])
			flash[:success] = "Successfully Updated Preview."
			redirect_to course_previews_path
		else
			render :edit
		end
	end

	def destroy
		@preview = CoursePreview.find(params[:id])

		@preview.destroy

		flash[:success] = "Successfully Destroyed Preview."
		redirect_to course_previews_path
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
