class CoursePricingsController < ApplicationController
  include CoursePricingsHelper
  load_and_authorize_resource
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
  before_filter :valid_domain_check, :only=>[:show,:edit]

  def new
    populate_combo_courses
    @coursepricing=@domain_root_account.course_pricings.new
  end

  def show
  end

  def create
    populate_combo_courses
    @coursepricing=CoursePricing.new(params[:course_pricing])
   @coursepricing.account_id=@account_id
    course_ids=CoursePricing.where("course_id=?",@coursepricing.course_id)
    if nooverlap?(course_ids,@coursepricing.start_date,@coursepricing.end_date)
      if(@coursepricing.start_date>=Date.today)
        if(@coursepricing.end_date>=@coursepricing.start_date)
          if @coursepricing.save
            flash[:notice]="Course price saved successfully"
            redirect_to manage_courses_path
          else
            render 'new'
          end
        else
          flash[:notice] = "End date should be greater than Start date"
          render :new
        end        
      else
        flash[:notice] = "Start Date should be greater than of equal current date."
        render :new
      end
    else
      flash[:notice] = "Price Details already defined for the date range"
      render :new
    end
  end

  def index
    populate_combo_courses
    if(params[:search] != nil && params[:search] != "")
      @coursepricings =[]
      @coursepricings = @domain_root_account.course_pricings.where("course_id=#{params[:search]}").paginate(page: params[:page], :per_page => 30)
    else
      populate_course_pricing
   end

  end

 def destroy
  @coursepricing=@domain_root_account.course_pricings.find(params[:id])
  if user_can_do?(@coursepricing)
  @coursepricing.destroy
  flash[:success] = "Successfully Destroyed Course Price."
  redirect_to manage_Courses_path
  else
    flash[:error] = "Not Authorized"
    redirect_to manage_Courses_path
  end
end

def edit
  populate_combo_courses

  @coursepricing=@domain_root_account.course_pricings.find(params[:id])
  if user_can_do?(@coursepricing)
    @course = @domain_root_account.courses
  else
    flash[:error] = "Not Authorized"
    redirect_to manage_Courses_path
  end

end

def update
  @coursepricing=@domain_root_account.course_pricings.find(params[:id])
  if user_can_do?(@coursepricing)
  @coursepricing_params=@domain_root_account.course_pricings.new(params[:course_pricing])
  @coursepricing.account_id=@domain_root_account.id
  course_ids=CoursePricing.where("course_id=? AND id!=?",@coursepricing_params.course_id,@coursepricing.id)
  if nooverlap?(course_ids,@coursepricing_params.start_date,@coursepricing_params.end_date)
   
      if(@coursepricing_params.end_date>=@coursepricing_params.start_date)
        
        if @coursepricing.update_attributes(params[:course_pricing])
          flash[:notice] = "Updated Course Price Details Successfully..."
          redirect_to course_pricings_path
        else
          render 'edit'
        end
      else
        flash[:notice] = "End date should be greater than Start date"
        render :edit
      end        
   
  else
    flash[:notice] = "Price Details already defined for the date range"
    render :edit
  end
  else
    flash[:error] = "Not Authorized"
    redirect_to manage_Courses_path
  end

end


end
