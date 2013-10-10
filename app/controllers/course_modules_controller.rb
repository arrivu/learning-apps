class CourseModulesController < ApplicationController

def new
  	@course_module=CourseModule.new

  end


  def create
  	@course_module=CourseModule.new(params[:course_module])
    @course_module.account_id=@account_id 
    course_id=CourseModule.where("course_id=?",@course_module.course_id)
      if @course_module.save
  		flash[:success]="Module created Successfully"
  		redirect_to course_library_page_path
    else
      render "new"
  	end
  end
  def edit
  	@course_module=CourseModule.find(params[:id])
  end
  def update
  	@course_module=CourseModule.find(params[:id])
  	if @course_module.update_attributes(params[:course_module])
  		flash[:success]="Module updated Successfully"
  		redirect_to course_library_page_path
       render "edit"
  	end
  end

   def show
  	@course_module=CourseModule.find(params[:id])
  end

  def index
  	@course_module=CourseModule.where(:account_id=>@account_id)
  end

  def destroy
   @course_module = CourseModule.find(params[:id])
      @course_module.destroy
      flash[:success] = "Module Deleted"
            redirect_to course_library_page_path
   end
end


