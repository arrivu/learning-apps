class CommentsController < ApplicationController
	
	before_filter :signed_in_user
	before_filter :load_commentable,:except=>[:new]

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

	protected

	def load_commentable
		@commentable = params[:commentable_type].camelize.constantize.find(params[:commentable_id])
		@comments = @commentable.comments.recent.limit(10).all
	end
	
# 	def user_review
#    if current_user.present?
#       obj = eval "#{params[:klass]}.find(#{params[:id]})"     
#       if params[:dimension].present?
#         obj.rate params[:score].to_i, current_user.id, "#{params[:dimension]}"       
#       else
#         obj.rate params[:score].to_i, current_user.id 
#       end
# 	end
# end
end