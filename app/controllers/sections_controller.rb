class SectionsController < ApplicationController

	def new
  	@section=Section.new

  end


  def create
  	@section=Section.new(params[:section])
    @section.account_id=@account_id
      if @section.save
  		flash[:success]="Section created Successfully"
  		redirect_to manage_courses_path
    else
      render "new"
  	end
  end
  def edit
  	@section=Section.find(params[:id])
  end
  def update
  	@section=Section.find(params[:id])
  	if @section.update_attributes(params[:section])
  		flash[:success]="Section updated Successfully"
  		redirect_to manage_courses_path
     else 
       render "edit"
  	end
  end

   def show
  	@section=Section.find(params[:id])
  end

  def index
  	@section=Section.where(:account_id=>@account_id)
  end

  def destroy
   @section = Section.find(params[:id])
      @section.destroy
      flash[:success] = "Section Deleted"
            redirect_to manage_courses_path
   end
end
