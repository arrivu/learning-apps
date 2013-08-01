class SlidersController < ApplicationController
    before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy]
    before_filter :subdomain_authentication , :only => [:new,:create, :edit,:index,:destroy]


  def show_image_slider    
    @slider = Slider.find(params[:id])
    send_data @slider.image, :type => @slider.image_type, :disposition => 'inline'
    # http_cache(@slider)
  end

  def background_image_slider   
    @slider = Slider.find(params[:id])
    send_data @slider.background_image, :type => @slider.background_image_type, :disposition => 'inline'
    # http_cache(@slider)
  end

  def new
  	@slider = Slider.new
  end

  def create
  	@slider = Slider.new(params[:slider])
    @slider.account_id=@account_id
  	if @slider.save
  		flash[:success] = "Created Sucessfully"
  		redirect_to sliders_path
  	end
  end

  def edit
    @slider= Slider.find(params[:id])
  end
  def update
 
      @slider = Slider.find(params[:id])
          @slider.account_id=@account_id

     if @slider.update_attributes(params[:slider])
      flash[:success] ="Successfully Updated Category."
      redirect_to sliders_path
    end

  end
  def show
    @slider = Slider.find(params[:id])
  end
  def destroy
    @slider = Slider.find(params[:id])
    @slider.destroy
    flash[:success] = "Successfully Destroyed Category."
    redirect_to sliders_path
  end
  def index
    @slider = Slider.where(:account_id=>@account_id).paginate(page: params[:page])

  end
  
end
