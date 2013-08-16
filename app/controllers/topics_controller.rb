class TopicsController < ApplicationController
   before_filter :valid_domain_check, :only=>[:show,:edit]
 before_filter :check_admin_user, :only => [:new,:create, :edit, :destroy,:index]
 before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
 @@id

 def index
  @topics = Topic.roots.where(:account_id=>@domain_root_account.id)
 end

    def show
      @topic = Topic.find(params[:id])
      @@topic=@topic
      @total_course_count = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id.to_s).size
      @courses = @topic.courses.where(ispublished: 1, :isconcluded=>false,account_id: @account_id).paginate(page: params[:page], :per_page => 6)

      @topics = Topic.where("parent_topic_id!=root_topic_id AND account_id =?", @account_id).order(:name)
    end

    def new
      @topic = Topic.new
    end

    def create

      @topic = Topic.new(params[:topic])
      # @topic.parent_topic_id=Topic.find(params[:id])
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
      def add_sub_topics
        params[:topic][:account_id]=@domain_root_account.id
       if @@topic.children.create(params[:topic])
          flash[:success] = "Successfully Created Category."
          redirect_to topics_path
        else
          render :new
        end
     end


end
