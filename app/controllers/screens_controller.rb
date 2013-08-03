class ScreensController < ApplicationController
  include ScreensHelper
  def home
    @courses = Course.all(:conditions => {:ispopular => 1,:account_id => @account_id},:limit => 6)
    @topics=Topic.where(:account_id => @account_id)
    @topics = @topics.sort_by {|x| x.name.length}
    @partners=Partner.all(:conditions => {:account_id => @account_id},:limit => 6)
    @testimonial=Testimonial.where(:account_id=>@account_id)
    @footerlinks=Footerlink.where(:account_id=>@account_id)
    @header_detail = HeaderDetail.where(:account_id=>@account_id)
    @slider = Slider.where(:account_id=>@account_id).paginate(page: params[:page])
    @social_stream_comments=SocialStreamComment.where(:account_id=>@account_id)
     
  end

  def about
     @aboutdetail = Aboutdetail.where(:account_id=>@account_id)
     @footerlinks=Footerlink.where(:account_id=>@account_id)
      @header_detail = HeaderDetail.where(:account_id=>@account_id)
  end

  def faq
  end

  def privacy
     @privacypolicy=Privacypolicy.where(:account_id=>@account_id)
     @footerlinks=Footerlink.where(:account_id=>@account_id)
      @header_detail = HeaderDetail.where(:account_id=>@account_id)
  end

  def termscondition
    @term = Term.where(:account_id=>@account_id)
    @footerlinks=Footerlink.where(:account_id=>@account_id)
     @header_detail = HeaderDetail.where(:account_id=>@account_id)
  end

  def knowledge_partners
     @partners=Partner.all(:conditions => {:account_id => @account_id},:limit => 6)
      @footerlinks=Footerlink.where(:account_id=>@account_id)
     @header_detail = HeaderDetail.where(:account_id=>@account_id)
  end

  def user_reviews
  end
  
  def construction
  end 
 def show_image_logo
    @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.logo, :type => @header_detail.logo_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end

  def theme_header_image    
    @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.theme, :type => @header_detail.theme_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end
end
