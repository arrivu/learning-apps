class TopicsController < ApplicationController
    load_and_authorize_resource
    before_filter :valid_domain_check, :only=>[:show,:edit]
    before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy,:index]
    caches_action :index,:show

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
        expire_action action:[:index,:show]
        expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
      else
        render :edit
      end
    end


    def new
      @topic = Topic.new(:parent_id => params[:parent_id])
      expire_action action:[:index,:show]
      expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
    end

    def create
      @topic = Topic.new(params[:topic])
      @topic.account_id =@domain_root_account.id
      if @topic.save
        expire_action action:[:index,:show]
        expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
        redirect_to topics_url
      else
        render :new
      end
    end

    def destroy
      @topic = Topic.find(params[:id])
      @topic.destroy
      expire_action action:[:index,:show]
      expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
      redirect_to topics_url
    end


end
