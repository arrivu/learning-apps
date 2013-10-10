class TopicsController < ApplicationController
    load_and_authorize_resource
    before_filter :valid_domain_check, :only=>[:show,:edit]
    before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]

    def index
      @topics = @domain_root_account.topics.scoped
      @topic = Topic.new
    end

    def show
      @courses = Topic.find(params[:id]).courses.paginate(page: params[:page], per_page: 6)
      @topics = @domain_root_account.topics
    end

    def edit
      @topic = Topic.find(params[:id])
    end

    def update
      @topic=Topic.find(params[:id])
      if @topic.update_attributes!(params[:topic])
        flash[:success]="Category Updated Successfully"
        redirect_to topics_path
      else
        render :edit
      end
    end


    def new
      @topic = Topic.new(:parent_id => params[:parent_id])
    end

    def create
      @topic = Topic.new(params[:topic])
      @topic.account_id =@domain_root_account.id
      if @topic.save
        redirect_to topics_path
      else
        render :new
      end
    end

    def destroy
      @topic = Topic.find(params[:id])
      @topic.destroy
      redirect_to topics_path
    end


end
