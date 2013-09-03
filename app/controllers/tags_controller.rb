class TagsController < ApplicationController

  before_filter :subdomain_authentication , :only => [:new,:create, :index, :edit, :destroy]
  before_filter :valid_domain_check, :only=>[:show,:edit]

  def index
    @tags = @domain_root_account.tags
    respond_to do |format|
      format.html
      format.json { render json: @tags.tokens(params[:q]) }
    end
  end


  def new
    @tag = Tag.new
  end

  def create
    if Tag.create(:name => params[:tag][:name],:account_id => @domain_root_account.id)
      redirect_to tags_path, notice: "Successfully created tag."
    else
      render :new
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      redirect_to tags_path, notice: "Successfully updated tag."
    else
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_url, notice: "Successfully destroyed tag."
  end
end
