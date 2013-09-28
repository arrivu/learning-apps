class CommentsController < ApplicationController
	
	before_filter :signed_in_user
	before_filter :load_commentable,:except=>[:new,:destroy]

	# def index
	# 	@comments =comments.recent.limit(10).all
	# end
	
	def new

		@comment = Comment.new
		@course = Course.find(params[:commentable])
		@commentable_type = params[:commentable_type]
		@commentable_id = params[:commentable]
		if signed_in? 
			unless RatingCache.find_by_cacheable_id(@course.id) == nil
				@qty = RatingCache.find_by_cacheable_id(@course.id).qty
			end
			@rated = Rate.find_by_rater_id(current_user.id)
		end
	end

	def create
		@comment = @commentable.comments.build(params[:comment])
		@comment.user_id = current_user.id
		@course = Course.find(params[:commentable_id])
		@commentable_type = params[:commentable_type]
		@commentable_id = params[:commentable_id]
		#@course = Course.find(params[:commentable])
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @commentable }
				flash[:info] = "Your review is added "
			else
				format.html { render :action => 'new' }
			end
		end
	end
	
	
	def destroy
    @comments = Comment.find(params[:id])
    # @comments.destroy
    @comments.is_active
    flash[:success] = "Successfully Destroyed Category."
    redirect_to :back
  end

  

	protected

	def load_commentable
		@commentable = params[:commentable_type].camelize.constantize.find(params[:commentable_id])
		@comments = @commentable.comments.recent.limit(10).all
	end
   def activate_comments
    @comments=Comment.find(params[:id])
    @comments.is_active = params[:comment][:is_active]
    if @comments.save!
      if @comments.is_active?
        
        redirect_to review_path
        flash[:success] = ""
      else
        redirect_to review_path
        
      end
    end

  end
  

end