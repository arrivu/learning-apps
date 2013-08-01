class AuthenticationController < ApplicationController
  include LmsHelper
  include CasHelper

  def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication
      # Authentication found, sign the user in.
      flash[:info] = "Welcome. #{authentication.user.name}"
      #sign_in_and_redirect(:user, authentication.user)
        if  @domain_root_account.account_users.where(:user_id=>authentication.user.id).empty?
           login_and_redirect_user(authentication.user)
              AccountUser.create(:user_id=>authentication.user.id,:account_id=>@account_id,:membership_type => "student")
       
       else
        login_and_redirect_user(authentication.user)
       end

     
     
    else
      # Authentication not found, thus a new user.
      email=auth['info']['email']
      check_user=User.find_by_email(email)

      if check_user
        provider=check_user.provider.split("_")
        provider=provider[0].capitalize
        if provider=="google_oauth2"
          provider="google"
        end
        flash[:error] = "Email id #{email} Already Registered using #{provider}"
        redirect_to root_url
      else
        user = User.new
        user.apply_omniauth(auth)
        if user.save(:validate => false)          
          Student.create(:user_id=>user.id,:name => user.name,:contact_no => user.phone)
          AccountUser.create(:user_id=>user.id,:account_id=>@account_id,:membership_type => "student")
       
          lms_create_user(user) if lms_enable?
          flash.now[:notice] = "Account created and signed in successfully."
          user.add_role(:student)
          #sign_in_and_redirect(:user, user)
          login_and_redirect_user(user)
        else
          flash.now[:error] = "Error while creating a user account. Please try again."
          redirect_to root_url
        end
      end
    end
  end




  private

      def login_and_redirect_user(user)
        #first sign-in to cas
        user_cas_sign_in(user)
        # sign-in the user in devise
        sign_in_and_redirect(:user, user)
      end

      def user_cas_sign_in (user)
        tgt = nil
        if cas_enable?
          begin
            tgt = cas_sign_in(user)
            #cookies[:tgt] = tgt
            # Sets a cookie with the domain            
            cookies[:tgt] = { :value => "#{tgt}", :domain => :all }  
          rescue Exception => e
            puts e.inspect
            puts "There is some error to sing_in to cas using user : #{user.inspect}"
            raise
          end
        end
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

