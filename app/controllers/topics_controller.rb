class TopicsController < ApplicationController
   before_filter :valid_domain_check, :only=>[:show,:edit]
 before_filter :check_admin_user, :only => [:new,:create, :edit, :destroy,:index]
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
 @@id
 def index
  #Topic.wh
  @topic_details = Topic.where("parent_id=? AND root_id=? AND account_id=?",0,0,@account_id).paginate(page: params[:page], :per_page => 10)
end

def show
  
  @topic = Topic.find(params[:id])
  @@id=@topic
  @total_course_count = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id.to_s).size
  @courses = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id).paginate(page: params[:page], :per_page => 6)

  @topics = Topic.where("parent_id!=root_id AND account_id =?", @account_id).order(:name)
end

def new
  @topic = Topic.new  
end

def create
  @topic = Topic.new(params[:topic])
  # @topic.parent_id=Topic.find(params[:id])
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
def category_details
 
  # Topic.whe
# @topic=Topic.find(params[:id])
  @topic = Topic.new(params[:topic])
   @topic.parent_id=@@id.id
  # @topic.parent_id=@topic.id
   @topicrootid=Topic.find(@topic.parent_id)
  if @topicrootid.parent_id == nil
     @topic.root_id=@topic.parent_id
   else
    # Topic.whe
    @topic.root_id=@topicrootid.parent_id
   end
  # Topic.wh
      @topic.account_id=@account_id
  if @topic.save
    flash[:success] = "Successfully Created Category."
    redirect_to topics_path
  else
    render :new
  end
end
# def sub_category_details
#   @topic = Topic.new(params[:topic])
# end


end
