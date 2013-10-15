class RaterController < ApplicationController 
  
  def create
    if current_user.present?
      obj = eval "#{params[:klass]}.find(#{params[:id]})"     
      if params[:dimension].present?
        obj.rate params[:score].to_i, current_user.id, "#{params[:dimension]}"       
      else
        obj.rate params[:score].to_i, current_user.id 
      end
      expire_action(controller: '/courses', action: [:index,:show,:background_image,:show_image])
      render :json => true 
    else
       respond_to do |format|
       format.js # index.html.erb

       format.json { render json: false }

       end        
    end
  end                                        
  
  
end