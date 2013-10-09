class RegistrationsController < Devise::RegistrationsController
  include CasHelper
  include LmsHelper
  include ApplicationHelper
  #after_filter :login_cas, :lms_create, :student_create, :only => [:create]
  caches_page :user_image
  def after_sign_up_path_for(resource)
   if redirect_back_req?
      redirect_back
    else
      courses_path
    end
  end

  def user_image
    @user = User.find(params[:id])
    send_data @user.image_blob, :type => @user.content_type, :disposition => 'inline'
  end

  def create
    @user=User.new(params[:user])
    if @user.save
     if @user.active_for_authentication?
       set_flash_message :notice, :signed_up if is_navigational_format?
       sign_up(resource_name, @user)
       #call cas sign to create the cas ticket
       cas_sign_in(current_user) if  cas_enable?
       respond_with @user, :location => after_sign_up_path_for(resource)
     else
       set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
       expire_session_data_after_sign_in!
       respond_with @user, :location => after_inactive_sign_up_path_for(@user)
     end
    else
     clean_up_passwords @user
     respond_with @user
    end
    # super
    if current_user
      student_create
      lms_create
      user_cas_sign_in current_user
      verify_user_status
    end
  end

  def update
    successfully_updated = if needs_password?(current_user, params)
    current_user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
    end
    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in current_user, :bypass => true
      redirect_to edit_user_registration_path
    else
      render "edit"
    end
  end

  def add_status(student)
    if @domain_root_account.open_student_registration?
      student.is_active =true
    else
      student.is_active =false
    end
  end

    private

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

    def student_create
      if current_user
       student= Student.create(:user_id=>current_user.id,:account_id=>@domain_root_account.id)
       add_status(student)
       student.save!
        current_user.add_role(:student)
        AccountUser.create(:user_id=>current_user.id,:account_id=>@domain_root_account.id)
      end
    end

    def lms_create
      if (current_user && lms_enable?)
        lms_create_user(current_user).delay
      end
    end
   
    # check if we need password to update user data
    # ie if password or email was changed
    # extend this as needed
    def needs_password?(user, params)
      user.email != params[:user][:email] || !params[:user][:password].blank?
    end
end
