class HeaderDetailsController < ApplicationController
  # caches_page :show_image_detail,:theme_image_detail
before_filter :subdomain_authentication , :only => [:new,:create, :index, :edit, :destroy]
   def show_image_detail  
    @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.logo, :type => @header_detail.logo_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end

  def theme_image_detail    
    @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.theme, :type => @header_detail.theme_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end
  def new
  	@header_detail = HeaderDetail.new
  end

  def create
  	@header_detail = HeaderDetail.new(params[:header_detail])
  	if @header_detail.save
  		flash[:success] = "Successfully create"
  		redirect_to header_details_path
     else
      render :action => 'new' 
  end
  end
  def edit

        @header_detail=HeaderDetail.find(params[:id])

  end

  def update
  
  @header_detail = HeaderDetail.find(params[:id])
         if @header_detail.update_attributes(params[:header_detail])
            flash[:success] = "Header Details updated"
            redirect_to header_details_path
          else
              render :action => 'edit'
          end
  end

  def show

    @header_detail = HeaderDetail.find(params[:id])

       # send_data @header_detail.logo, :type => @header_detail.logo_type, :disposition => 'inline' 
       # render :show_image

  end

  

  def index
    @header_detail = HeaderDetail.paginate(page: params[:page])
  end
  
   def destroy
   @header_detail = HeaderDetail.find(params[:id])
      @header_detail.destroy
      flash[:success] = "Header Details Deleted"
            redirect_to header_details_path
   end
   
end
