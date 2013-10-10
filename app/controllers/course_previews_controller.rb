class CoursePreviewsController < ApplicationController
  include CoursePreviewsHelper
  load_and_authorize_resource
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
  before_filter :valid_domain_check, :only=>[:show,:edit]
	def new
		@preview = CoursePreview.new
    populate_combo_courses
	end

	def create
    populate_combo_courses
		@course=Course.find(params[:id])
		params[:course_preview][:account_id]=@domain_root_account.id
		@preview =@course.course_previews.build(params[:course_preview])
		# @preview.account_id=
		if @preview.save
			flash[:success] = "Preview Added Successfully."
			redirect_to course_library_page_path
		else
		
		render 'new'

		end
	end

	def index
    populate_course_previews
    populate_combo_courses
	end

  
	def edit
		@preview= CoursePreview.find(params[:id])
    if user_can_do?(@preview)
      populate_combo_courses
      @preview
    else
      flash[:error] = "Not Authorized"
      redirect_to course_library_page_path
    end

	end

	def update
		@preview = CoursePreview.find(params[:id])
    if user_can_do?(@preview)
	   		@preview.account_id=@account_id
		if @preview.update_attributes(params[:course_preview])
			flash[:success] = "Successfully Updated Preview."
			redirect_to course_library_page_path
		else
			render :edit
    end
    else
      flash[:error] = "Not Authorized"
      redirect_to course_library_page_path
    end
	end

	def destroy
		@preview = CoursePreview.find(params[:id])
    if user_can_do?(@preview)
		@preview.destroy

		flash[:success] = "Successfully Destroyed Preview."
		redirect_to course_library_page_path
    else
      flash[:error] = "Not Authorized"
      redirect_to course_library_page_path
    end
	end



end
