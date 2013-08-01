class SlidersController < ApplicationController
    before_filter :check_admin_user,:only => [:new,:create,:edit,:show,:update,:destroy]
    before_filter :subdomain_authentication , :only => [:new,:create, :edit, :destroy]


  def show_image    
    @slider = Slider.find(params[:id])
    send_data @slider.image, :type => @slider.imagetype, :disposition => 'inline'
    # http_cache(@slider)
  end

  def background_image    
    @slider = Slider.find(params[:id])
    send_data @slider.backgroundimage, :type => @slider.backgroundimagetype, :disposition => 'inline'
    # http_cache(@slider)
  end

  def new
  	@slider = Slider.new
  end

  def create
  	@slider = Slider.new(params[:slider])
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
    @slider = Slider.paginate(page: params[:page])
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
