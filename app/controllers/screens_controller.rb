class ScreensController < ApplicationController
  include ScreensHelper
  def home
    @courses = Course.all(:conditions => {:ispopular => 1,:account_id => @account_id},:limit => 6)
    @topics=Topic.where(:account_id => @account_id)
    @topics = @topics.sort_by {|x| x.name.length}
    @partner=Partner.all(:conditions => {:account_id => @account_id},:limit => 6)
    @testimonial=Testimonial.where(:account_id=>@account_id)
    @footerlinks=Footerlink.where(:account_id=>@account_id)
    

  end

  def about
     @aboutdetail = Aboutdetail.where(:account_id=>@account_id)
     @footerlinks=Footerlink.where(:account_id=>@account_id)
  end

  def faq
  end

  def privacy
     @privacypolicy=Privacypolicy.where(:account_id=>@account_id)
     @footerlinks=Footerlink.where(:account_id=>@account_id)
  end

  def terms
    @term = Term.where(:account_id=>@account_id)
    @footerlinks=Footerlink.where(:account_id=>@account_id)
  end

  def knowledge_partners
  end

  def user_reviews
  end
  
  def construction
  end 

end
