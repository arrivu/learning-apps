module ApplicationHelper
		# Returns the full title on a per-page basis.
		def full_title(page_title)
			base_title = "Beacon Learning"
			@page_title = page_title
			if page_title.empty?
				base_title
			else
				"#{base_title} | #{page_title}"
			end
		end

		def check_null(str)
			if str.empty?
				true
			else
				false
			end
		end

		def display_base_errors resource
			return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
			messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
			html = <<-HTML
			<div class="alert alert-error alert-block">
				<button type="button" class="close" data-dismiss="alert">&#215;</button>
				#{messages}
			</div>
			HTML
			html.html_safe
		end

		def check_admin_user
			authenticate_user!
			if current_user.has_role? :account_admin 
			 return
			elsif current_user.has_role? :admin
				return
			else	

     redirect_to root_url # or whatever
   end
   
  		 

end


  def http_cache(instant_variable,scope=true,expires=15)
    unless RAILS.env.development?
      expires_in expires.minutes
      fresh_when instant_variable, public: scope
    end
  end
  #  def http_cache(instant_variable,scope=true)
  #    fresh_when instant_variable, public: scope
  #  end
 

  def subdomain_authentication
       :authenticate_user!
       if current_user.has_role? :student
       	  if !@subdomain_id= AccountUser.where(:user_id=>current_user.id , :account_id=>@account_id).empty?
       	   
        	return
      		else
      			 @subdomain_id= AccountUser.find_by_user_id(current_user.id)
        	redirect_to request.url.sub(current_subdomain, @subdomain_id.account.name)
        # redirect_to root_path(:subdomain => @subdomain_name)
      		end
      elsif !current_user.has_role?  :admin
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
   def account_create_restrict
   	if current_user.has_role? :admin
   		return
   	else
      flash[:error] = "Invalid authenticator"
   		redirect_to users_url
   	end

   end
   
end
