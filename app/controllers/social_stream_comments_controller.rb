class SocialStreamCommentsController < ApplicationController
  before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]
  def new
  	@social_stream_comments=SocialStreamComment.new
  end
  def create
  	@social_stream_comments=SocialStreamComment.new(params[:social_stream_comment])
  	@social_stream_comments.account_id=@account_id
  	if @social_stream_comments.save
  		flash[:success]="Social Stream comments Submitted Successfully"
  		redirect_to social_stream_comments_path
  	else
  		render 'new'
  	end
  end

  def edit
  	@social_stream_comments=SocialStreamComment.find(params[:id])
  end

  def index
  	@social_stream_comments=SocialStreamComment.where(:account_id=>@account_id)
  end
  def update
  	@social_stream_comments=SocialStreamComment.find(params[:id])
  	@social_stream_comments.account_id=@account_id
  	if @social_stream_comments.update_attributes(params[:social_stream_comment])
  		flash[:success]="Social Stream comments Submitted Successfully"
  		redirect_to social_stream_comments_path
  	else
  		render 'edit'
  	end
  end

  def show
  	@social_stream_comments=SocialStreamComment.find(params[:id])

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
