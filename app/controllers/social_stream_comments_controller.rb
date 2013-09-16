class SocialStreamCommentsController < ApplicationController
  load_and_authorize_resource
   before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index]
    before_filter :valid_domain_check, :only=>[:show,:edit]
    before_filter :front_page_registration_restrict, :only=>[:new,:create]
  def new
  	@social_stream_comment=SocialStreamComment.new
  end
  def create
  	@social_stream_comment=SocialStreamComment.new(params[:social_stream_comment])
  	@social_stream_comment.account_id=@account_id
  	if @social_stream_comment.save
  		flash[:success]="Social Stream comments Submitted Successfully"
  		redirect_to social_stream_comments_path
  	else
  		render 'new'
  	end
  end

  def edit
  	@social_stream_comment=SocialStreamComment.find(params[:id])
  end

  def index
  	@social_stream_comments=SocialStreamComment.where(:account_id=>@account_id)
  end
  def update
  	@social_stream_comment=SocialStreamComment.find(params[:id])
  	@social_stream_comment.account_id=@account_id
  	if @social_stream_comment.update_attributes(params[:social_stream_comment])
  		flash[:success]="Social Stream comments Submitted Successfully"
  		redirect_to social_stream_comments_path
  	else
  		render 'edit'
  	end
  end

  def show
  	@social_stream_comments=SocialStreamComment.find(params[:id])

  end
  
end
