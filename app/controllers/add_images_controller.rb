class AddImagesController < ApplicationController
  def new
  	@addimage= AddImage.new
  end
  def create
  	@addimage = AddImage.new(params[:add_image]) 
  	@addimage.account_id=@account_id####:add_images tablename singular
  	if @addimage.save
			  flash[:success] = "Image added "
			      # NewsletterMailer.weekly("ankithbti007@gmail.com", flash[:success]).deliver
			  redirect_to add_images_path

			else
			  render :action => 'new'
			end
  end

  def edit
  	@addimage=AddImage.find(params[:id])

  end
  def update
				 @addimage = AddImage.find(params[:id])
				 @addimage.account_id=@account_id
         if @addimage.update_attributes(params[:add_image])
        		flash[:success] = "Image Updated"
        			redirect_to add_images_path
        	else
        			render :action => 'edit'
      		end
  end	
  def index
  	@addimage=AddImage.paginate(page: params[:page], :per_page => 15)
  end

  def show

    @addimage = AddImage.find(params[:id])

      send_data @addimage.image, :type => @addimage.image_type, :disposition => 'inline' 
  end
  def destroy
  	
  	@addimage = AddImage.find(params[:id])
      @addimage.destroy
      flash[:success] = "Image Details Deleted"
      redirect_to add_images_path
  end	
end
