class CoursePricingsController < ApplicationController
  include CoursePricingsHelper
  before_filter :check_admin_user, :only => [:new,:create, :edit, :destroy,:index]
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
  def new
    @coursepricing=CoursePricing.new
  end

  def show
  end
  def create
    @coursepricing=CoursePricing.new(params[:course_pricing])
    
   @coursepricing.account_id=@account_id
    course_ids=CoursePricing.where("course_id=?",@coursepricing.course_id)
    if nooverlap?(course_ids,@coursepricing.start_date,@coursepricing.end_date)
      if(@coursepricing.start_date>=Date.today)
        if(@coursepricing.end_date>=@coursepricing.start_date)
          if @coursepricing.save
            flash[:notice]="Course price saved successfully"
            redirect_to course_pricings_path
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
    if(params[:search] != nil && params[:search] != "")
      @coursepricing = CoursePricing.where("course_id=#{params[:search]}").paginate(page: params[:page], :per_page => 15)
    else
     @coursepricing = CoursePricing.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 15)
   end
   @course = Course.where(:account_id=>@account_id).paginate(page: params[:page], :per_page => 15)
 end

 def destroy
  @coursepricing=CoursePricing.find(params[:id])

  @coursepricing.destroy

  flash[:success] = "Successfully Destroyed Course Price."
  redirect_to course_pricings_path
end

def edit
 @coursepricing=CoursePricing.find(params[:id])
 @course = Course.all
end




def update

  @coursepricing=CoursePricing.find(params[:id])
  @coursepricing_params=CoursePricing.new(params[:course_pricing])
  @coursepricing.account_id=@account_id
   
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
