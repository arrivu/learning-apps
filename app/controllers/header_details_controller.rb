class HeaderDetailsController < ApplicationController
  # caches_page :show_image_detail,:theme_image_detail
  load_and_authorize_resource
   before_filter :subdomain_authentication, :only=>[:new, :create, :edit, :index,:show_image_detail]
    before_filter :valid_domain_check, :only=>[:show,:edit]
   before_filter :front_page_registration_restrict, :only=>[:new,:create]
   def show_image_detail  
    @header_detail =HeaderDetail.find(params[:id])
    # @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.logo, :type => @header_detail.logo_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end

  def theme_image_detail    
    @header_detail = HeaderDetail.find(params[:id])
    send_data @header_detail.theme, :type => @header_detail.theme_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end

  def show_image_show  
    @header_detail = HeaderDetail.find_by_account_id(params[:account_id])
    send_data @header_detail.logo, :type => @header_detail.logo_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end

  def theme_image_show  
    @header_detail = HeaderDetail.find_by_account_id(params[:account_id])
    send_data @header_detail.theme, :type => @header_detail.theme_type, :disposition => 'inline'
    # http_cache(@header_detail)
  end
 
  def new
    @header=HeaderDetail.find_by_account_id(@account_id)
    if @header == nil
      @header_detail = HeaderDetail.new
    else
      redirect_to header_details_path
    end


  end

  def create
  	@header_detail = HeaderDetail.new(params[:header_detail])
    if(params[:header_detail][:logo_name]!=nil)
     params[:header_detail][:logo_name].original_filename= params[:header_detail][:logo_name].original_filename + "#{(Time.now.to_i.to_s + Time.now.usec.to_s).ljust(16, '0')}#{File.extname(params[:header_detail][:logo_name].original_filename)}"
      file_name=params[:header_detail][:logo_name].original_filename
      directory="#{Rails.root}/public/images"
      path=File.join(directory,file_name)
      File.open(path, "wb") { |f| f.write(params[:header_detail][:logo_name].read) }
      @header_detail.logo_name=file_name
     end
        @header_detail.account_id=@account_id
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
   if(params[:header_detail][:logo_name]!=nil)
      params[:header_detail][:logo_name].original_filename= params[:header_detail][:logo_name].original_filename + "#{(Time.now.to_i.to_s + Time.now.usec.to_s).ljust(16, '0')}#{File.extname(params[:header_detail][:logo_name].original_filename)}"
      file_name=params[:header_detail][:logo_name].original_filename
      directory="#{Rails.root}/public/images"
      path=File.join(directory,file_name)

      if(@header_detail.logo_name!=nil && File.exists?("#{Rails.root}/public/images/"+@header_detail.logo_name))
        File.delete( "#{Rails.root}/public/images/" +@header_detail.logo_name)
      end
      File.open(path, "wb") { |f| f.write( params[:header_detail][:logo_name].read)}
       params[:header_detail][:logo_name]=file_name      
    else
       params[:header_detail][:logo_name]=@header_detail.logo_name

    end
  @header_detail.account_id=@account_id
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
    @header_detail = HeaderDetail.where(:account_id=>@account_id).paginate(page: params[:page])
  end
  
   def destroy
   @header_detail = HeaderDetail.find(params[:id])
      @header_detail.destroy
      flash[:success] = "Header Details Deleted"
            redirect_to header_details_path
   end
   
end
