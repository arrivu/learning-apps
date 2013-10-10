class CoursesController < ApplicationController
  include LmsHelper
  helper_method :course_user_count
  ActiveMerchant::Billing::Integrations
  load_and_authorize_resource
  before_filter :valid_domain_check, :only=>[:show,:edit]
  before_filter :subdomain_authentication, :only => [:new,:create, :edit, :destroy,:manage_courses,:course_status_search,
   :completed_courses,:updatecompleted_details,:conclude_course,:concluded_course_update]
  @@course_id
  caches_action :index,:show,:background_image,:show_image

  def show_image
    @course = Course.find(params[:id])
    send_data @course.data, :type => @course.content_type, :disposition => 'inline'
  end

  def background_image    
    @course = Course.find(params[:id])
    send_data @course.background_image, :type => @course.background_image_type, :disposition => 'inline'
  end

  def index
    add_breadcrumb "Courses", courses_path
   if @account_id!=nil
     @total_course_count = Course.where(ispublished: 1,isconcluded: "f",account_id: @account_id).all.count
     @countCoursesPerPage = 6
         if params[:mycourses]=="mycourses"
       @courses = Course.where(user_id: current_user.id, isconcluded: "f",account_id: @account_id).paginate(page: params[:page], per_page: 6)
     else
       @courses = Course.where(ispublished: 1,isconcluded: "f",account_id: @account_id).paginate(page: params[:page], :per_page => 6)
     end
     @topics = @domain_root_account.topics
      else
     @courses = Course.where(ispublished: 1,isconcluded: "f",global:"t").paginate(page: params[:page], :per_page => 6)
     @topics = @domain_root_account.topics
  end

 end

 def new
  add_breadcrumb "Add Course", new_course_path
  expire_action action: [:index,:show,:background_image,:show_image]
   @course = Course.new
   @topic = Topic.all
 end


 def create
   tags_token = params[:course][:tag_tokens]
   params[:course].delete :tag_tokens
   @course = Course.new(params[:course])
   @course.account_id=@domain_root_account.id
   @course.isconcluded="f"
   if @course.save
     tag_list(tags_token,@course)
     flash[:success] = "Course added successfully!!!!"
     expire_action action: [:index,:show,:background_image,:show_image]
     lms_create_course(@course)
     redirect_to manage_courses_path
   else
     render 'new'
   end

 end

 def edit
  add_breadcrumb "Add Course", edit_course_path
     @course= @domain_root_account.courses.find(params[:id])
     if user_can_do?(@course)
   else
     flash[:error] = "Not Authorized"
     redirect_to manage_courses_path
   end
 end

 def update
   @course = @domain_root_account.courses.find(params[:id])
   old_teaching_staff_id=@course.teaching_staff_ids
   tags_token = params[:course][:tag_tokens]
   params[:course].delete :tag_tokens
   if @course.update_attributes(params[:course])
     tag_list(tags_token,@course)
     lms_update_course(@course,old_teaching_staff_id).delay
     flash[:success] ="Successfully Updated Course."
     expire_action action: [:index,:show,:background_image,:show_image]
     redirect_to manage_courses_path
   else
     render :edit
   end
 end

 def show
  add_breadcrumb @course.title, course_path
   @course = @domain_root_account.courses.find(params[:id])
   @@course_id=@course
   @price_detail = CoursePricing.find_by_course_id(@course.id)
   if @price_detail!=nil
      @price=@price_detail.price
   end
   @authors= @course.teaching_staffs
   if(current_user!=nil)
    student=Student.where(user_id: current_user.id).first
    @status_check = StudentCourse.find_by_student_id_and_course_id(student,@course.id)
    if @status_check!=nil
      @status=@status_check.status

    end
  end

  @modules=lms_get_modules(@course)
    #@countCommentsPerPage = 6
    @comments = @course.comments.paginate(page: params[:page], per_page: 4)
    #@count = @course.comments.count
    if signed_in?
      unless RatingCache.find_by_cacheable_id(@course.id) == nil
        @qty = RatingCache.find_by_cacheable_id(@course.id).qty
      end

      @rated = Rate.find_by_rater_id(current_user.id)
    end

   @subscribers_count = @course.student_courses.where(status== "enroll").count
  end


  def upcomming_courses
    @total_course_count = Course.where(ispublished: 0,:isconcluded=>false,account_id: @account_id).all.count
    @countCoursesPerPage = 6
    @courses = Course.where(ispublished: 0,:isconcluded=>false,account_id: @account_id).paginate(page: params[:page], per_page: 6)
    @topics = Topic.where("parent_topic_id!=root_topic_id").order(:name)
  end

  def popular_courses
    @total_course_count = Course.where(ispopular: 1,:isconcluded=>false,ispublished: 1,account_id: @account_id).all.count
    @countCoursesPerPage = 6
    @courses = Course.where(ispopular: 1,ispublished: 1,:isconcluded=>false,account_id: @account_id).paginate(page: params[:page], per_page: 6)
    @topics = Topic.where("parent_topic_id!=root_topic_id").order(:name)
  end

  def datewise_courses
    @total_course_count = Course.where(ispublished: 1,:isconcluded=>false,account_id: @account_id).all.count
    @countCoursesPerPage = 6
    @courses = Course.where(ispublished: 1,:isconcluded=>false,account_id: @account_id).order(:created_at).paginate(page: params[:page], per_page: 6)
    @topics = Topic.where("parent_topic_id!=root_topic_id").order(:name)
  end

    # Just to redirect, needed due to button click event
    # @courses = Course.paginate(page: params[:page], per_page: 3)
    # @topics = Topic.all
    #@courses = Course.all


    def destroy
      @course = Course.find(params[:id])
      lms_id=@course.lms_id
      @course.destroy
      lms_delete_course(lms_id)
      expire_action action: [:index,:show,:background_image,:show_image]
      flash[:success] = "Successfully destroyed course."
      redirect_to manage_courses_url
    end

    def manage_courses
      @courses=[]
      if current_user.has_role? :teacher
        current_user.teaching_staff.teaching_staff_courses.each do |c|
        @courses << c.course
        end
        @courses=@courses.where(isconcluded: "f").paginate(page: params[:page], :per_page => 30)
      else
        @courses = @domain_root_account.courses.where(isconcluded: "f").paginate(page: params[:page],
                                                                                 :per_page => 30).order(:id)
      end
      @topic = @domain_root_account.topics
    end

    def course_status_search
      if(params[:search] == nil || params[:search] == "" && params[:searchstatus]=='All')
        @coursesstauts = StudentCourse.where("status!='shortlisted' AND account_id=?",@account_id).paginate(page: params[:page], :per_page => 30)
      elsif(params[:search] != nil && params[:search] != "" && params[:searchstatus]=='All' )
        @coursesstauts = StudentCourse.where("course_id='#{params[:search]}' AND account_id=?",@account_id ).paginate(page: params[:page], :per_page => 30)
      elsif(params[:search] != nil && params[:search] != "" && params[:searchstatus]!=nil && params[:searchstatus]!="")
        @coursesstauts = StudentCourse.where("course_id='#{params[:search]}' and status='#{params[:searchstatus]}' AND account_id=?",@account_id).paginate(page: params[:page], :per_page => 30)

      elsif(params[:search] == nil || params[:search] == "" && params[:searchstatus]!=nil && params[:searchstatus]!="")
        @coursesstauts = StudentCourse.where("status='#{params[:searchstatus]}' AND account_id=?",@account_id).paginate(page: params[:page], :per_page => 30)

      else
        @coursesstauts = StudentCourse.where("status!='shortlisted'AND account_id=?",@account_id).paginate(page: params[:page], :per_page => 30)
      end
    end


    def subscribed_courses
      @total_course_count =@domain_root_account.student_courses.where(:status =>"enroll").map(&:course_id).uniq.size
      @courses = @domain_root_account.courses.where(id: @domain_root_account.student_courses.where(:status =>"enroll").
          map(&:course_id).uniq).paginate(page: params[:page], per_page: 6)
      @countCoursesPerPage = 6
      @topics = @domain_root_account.topics.where("parent_topic_id!=root_topic_id").order(:name)
    end

    def my_courses
      @enrolled_courses  = []
      @completed_courses = []
      student=Student.where(user_id: current_user.id).first
      if !!student
        @enrolled_courses= student.course_enroll
        @completed_courses=student.course_complete
      else
        teaching_staff=TeachingStaff.where(user_id: current_user.id).first
        if !!teaching_staff
          teaching_staff_course =  teaching_staff.courses
          @enrolled_courses = teaching_staff_course.map { |teaching_staff_course| teaching_staff_course.course }
        end
      end
    end
    
    def completed_courses
      @coursesstauts=StudentCourse.find(params[:id])
    end

    def updatecompleted_details
      @coursesstauts=StudentCourse.find(params[:id])
      if @coursesstauts.update_attributes(status:params[:status])
        flash[:notice] = "Successfully Updated"
        lms_conclude_enrollment(@coursesstauts.course.lms_id,@coursesstauts.student.user.lms_id)
        redirect_to course_status_search_path
      else
        render course_status_search
      end
    end
#dont remove this method, this is for the page conclude_courses.html.erbs
  def conclude_course
    populate_combo_courses
  end

  def concluded_course_update
    if params[:search]==""
      flash[:notice] = "Please choose a course"
      render :conclude_course
    elsif params[:isconcluded]==nil
      flash[:notice] = "Please select a Conclude check box to Conclude this course"
      render :conclude_course
    else  
      @course_id=Course.find(params[:search])
      if StudentCourse.find_by_course_id(@course_id)!=nil
        @student_course_status=StudentCourse.find_by_course_id(@course_id)
        if @student_course_status.status=="enroll"
          flash[:notice] = "This course is already enrolled by User"
          render :conclude_course
        else
          if @course_id.update_attributes(isconcluded:params[:isconcluded],concluded_review:params[:concluded_review])
            flash[:notice] = "Course Successfully Concluded..."
            lms_conclude_course(@course_id.lms_id)
            redirect_to conclude_course_path
          else
            render :conclude_course
          end
        end
      else
        if @course_id.update_attributes(isconcluded:params[:isconcluded],concluded_review:params[:concluded_review])
          flash[:notice] = "Course Successfully Concluded..."
          lms_conclude_course(@course_id.lms_id)
          redirect_to conclude_course_path
        else
          render :conclude_course
        end
      end
    end
  end

  def concluded_courses
    @all_concluded_courses=Course.where("isconcluded=?","t")
  end

  def edit_concluded_course
    @course=Course.find(params[:id])
  end

  def update_un_concluded_course
    @course=Course.find(params[:id])
    if params[:isconcluded]==nil 
      params[:isconcluded]="f"
    end
    if @course.update_attributes(isconcluded:params[:isconcluded],concluded_review:params[:concluded_review])
      flash[:notice] = "Course Successfully Concluded..."
      lms_conclude_course(@course.lms_id)

      redirect_to concluded_courses_path
    else
      render :conclude_course
    end
  end

 def add_account_id
      @course= @@course_id
    if !current_user.has_role?  :admin

      if AccountUser.where(:user_id=>current_user.id ,  :account_id=> @account_id).empty?
          if current_user.has_role? :student
            AccountUser.create(:user_id=>current_user.id,:account_id=>@account_id,:membership_type => "student")
            

              redirect_to payments_confirm_course_payment_path(:id=>@course.id)
          elsif current_user.has_role? :teacher
             AccountUser.create(:user_id=>current_user.id,:account_id=>@account_id,:membership_type => "teacher")
           
            redirect_to payments_confirm_course_payment_path(:id=>@course.id)
         end 
       end
    end
 end

  def tag_list(tags_token,course)
    tags_list= tags_token.gsub!(/<<<(.+?)>>>/) { Tag.find_or_create_by_name_and_account_id(name: $1,account_id: @domain_root_account.id).id }
     if tags_list.nil?
         delete_tags(course,tags_token)
         tags_token.split(",").map do |n|
             Tagging.find_or_create_by_tag_id_and_course_id(tag_id: n.to_i, course_id: course.id)
          end
     else
         tags_list.split(",").map do |n|
           Tagging.find_or_create_by_tag_id_and_course_id(tag_id: n.to_i, course_id: course.id)
         end
     end

  end

  def delete_tags(course,tags_token)
    tag_id_arr = Array.new
    course.tags.each do |tag|
      tag_id_arr  << tag.id.to_s
    end
    tag_array =tags_token.split(",")
    deleted_tag=  tag_id_arr - tag_array
    unless deleted_tag.nil?
      deleted_tag.each do |tag_id|
        course.taggings.find_by_tag_id(tag_id).destroy
      end
    end
  end




  def tagged_courses
    @total_course_count =Tag.find(params[:tag]).courses.size
    @courses = Tag.find(params[:tag]).courses.paginate(page: params[:page], per_page: 6)
    @countCoursesPerPage = 6
    @topics = Topic.where("parent_topic_id!=root_topic_id").order(:name)
  end


  def get_modules
    @courses=Courses.all
    @courses.each do |c|
      @module=lms_get_modules(c)
    end


  end


end


