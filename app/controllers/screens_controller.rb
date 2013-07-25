class ScreensController < ApplicationController
  include ScreensHelper
  def home
    @courses = Course.all(:conditions => {:ispopular => 1,:account_id=>@account_id},:limit => 6)
    @topics=Topic.where(:account_id=>@account_id)
    @topics = @topics.sort_by {|x| x.name.length}
  end

  def about
  end

  def faq
  end

  def privacy
  end

  def terms
  end

  def knowledge_partners
  end

  def user_reviews
  end
  
  def construction
  end 

end
