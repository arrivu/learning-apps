class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_admin_user, :only => [:show, :destroy,:index,:interested_users]
  before_filter :subdomain_authentication , :only => [:show, :destroy,:index,:interested_users]
  require 'csv'
  
  def index
      @topics= Topic.where("parent_topic_id!=root_topic_id AND account_id =?", @domain_root_account.id)
      @topics = @topics.sort_by {|x| x.name.length} 
    # authorize! :index, @user, :message => 'Not authorized as an administrator.'
    
    query = "%#{params[:query]}%"
      if params[:provider]==nil
        @users = User.joins(:account_users).where('account_users.account_id = ?', @domain_root_account.id).paginate(page: params[:page], :per_page => 10)

        @total_users =  User.joins(:account_users).where('account_users.account_id = ?', @domain_root_account.id).count
      else
        if params[:provider]!="All"
          if(params[:query] == nil || params[:query] == "")
            @users = User.joins(:account_users).where("provider = ? and account_users.account_id = ?",params[:provider],@domain_root_account.id).all.paginate(page: params[:page], :per_page => 10)
            @total_users = User.joins(:account_users).where("provider = ?and account_users.account_id = ?",params[:provider],@domain_root_account.id).count
          else
            @users = User.joins(:account_users).where("(lower(name) like ? or lower(email) like ?) and provider = ? and account_users.account_id = ?" , query.downcase,query.downcase,params[:provider],@domain_root_account.id).paginate(page: params[:page], :per_page => 10)
             @total_users = User.joins(:account_users).where("(lower(name) like ? or lower(email) like ?) and provider = ? and account_users.account_id = ?" , query.downcase,query.downcase,params[:provider],@domain_root_account.id).count
          end
        else
          if(params[:query] != "")
            @users = User.joins(:account_users).where("lower(name) like ? or lower(email) like ? and account_users.account_id = ?", query.downcase,query.downcase,@domain_root_account.id).paginate(page: params[:page], :per_page => 10) 
             @total_users = User.joins(:account_users).where("lower(name) like ? or lower(email) like ? and account_users.account_id = ?", query.downcase,query.downcase,@domain_root_account.id).count
          else
            @users = User.joins(:account_users).where('account_users.account_id = ?', @domain_root_account.id).paginate(page: params[:page], :per_page => 10)
            @total_users = User.joins(:account_users).where('account_users.account_id = ?', @domain_root_account.id).count
        end
      end  
    end

    
  end

  def show
    @user = User.find(params[:id])
    if @user.has_role? :student
      @student=Student.where(user_id: @user.id).first
      @enrolled_courses=Course.joins(:student_courses).where('student_courses.status = ? and student_courses.student_id=? and student_courses.account_id=?', "enroll",@user.student.id,@domain_root_account.id) 
       @completed_courses=Course.joins(:student_courses).where('student_courses.status = ? and student_courses.student_id=? and student_courses.account_id=?', "completed",@user.student.id,@domain_root_account.id) 

      # @enrolled_courses= @student.course_enroll
      # @completed_courses=@student.course_complete        
    end
  end
  
  def update
    # authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
  
  def destroy
    # authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    users = User.find(params[:id])
    unless users == current_user
      users.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
  def interested_users
    query = "%#{params[:search]}%"
    if params[:search]==nil || params[:search]=="All" || params[:search] == ""
      @users =  StudentCourse.where("status= ?","follow").paginate(page: params[:page], :per_page => 10) 
        @total_users = @users.count
         
    else
      @users = StudentCourse.where("status= ? and course_id=?","follow",params[:search]).paginate(page: params[:page], :per_page => 10) 
    @total_users = StudentCourse.where("status= ? and course_id=?","follow",params[:search]).count
    
    end
    respond_to do |format|
    format.html
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
  end  
      

    end
    
    
end
