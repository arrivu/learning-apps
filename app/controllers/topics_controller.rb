class TopicsController < ApplicationController
  before_filter :subdomain_authenticate, :only => [:show]
 before_filter :check_admin_user, :only => [:new,:create, :edit, :destroy,:index]
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
 def index
  @topics = Topic.where(account_id: @account_id).paginate(page: params[:page], :per_page => 10)
end

def show
  @topic = Topic.find(params[:id])
  @total_course_count = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id.to_s).size
  @courses = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id).paginate(page: params[:page], :per_page => 6)

  @topics = Topic.where(:account_id=>@account_id).order(:name)
end

def new
  @topic = Topic.new  
end

def create
  @topic = Topic.new(params[:topic])
  
      @topic.account_id=@account_id
  if @topic.save
    flash[:success] = "Successfully Created Category."
    redirect_to topics_path
  else
    render :new
  end
end

def edit
  @topic = Topic.find(params[:id])
end

def update
  @topic = Topic.find(params[:id])
  @topic.account_id=@account_id
  if @topic.update_attributes(params[:topic])
    flash[:success] ="Successfully Updated Category."
    redirect_to topics_path
  else
    render :edit
  end
end

def destroy
  @topic = Topic.find(params[:id])
  @coursecheck=Course.where(topic_id: @topic.id )
  if @coursecheck!=[]
    flash[:error] = "This category cannot be deleted"
    redirect_to topics_path
  else
    @topic.destroy
    flash[:success] = "Successfully Destroyed Category."
    redirect_to topics_url
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
